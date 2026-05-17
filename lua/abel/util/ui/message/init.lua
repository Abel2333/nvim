--------------------------------------------------------------------------------
-- Message subsystem coordinator.
-- Bootstrap installs adapters and history storage.
-- Start wires the live renderer and optional history recorder into the bus.
--------------------------------------------------------------------------------
local Bus = require 'abel.util.tool.bus'
local M = {}

---@class MessageBootstrapOpt
---@field bus? BusInitOpt
---@field history? MessageHistoryOpt
---@field nvim? MessageNvimOpt
---@field notify? MessageNotifyOpt

---@class MessageStartOpt
---@field subscribers? BusSubscriberDecl[]
---@field bus_backend? string
---@field minimal_renderer? boolean Enable default toast-backed renderer

---@class MessageSetupOpt
---@field bus? BusInitOpt
---@field history? MessageHistoryOpt
---@field nvim? MessageNvimOpt
---@field notify? MessageNotifyOpt
---@field subscribers? BusSubscriberDecl[]
---@field bus_backend? string
---@field minimal_renderer? boolean Enable default toast-backed renderer

---@class MessageRuntimeState
---@field bootstrapped boolean
---@field started boolean

---@type MessageRuntimeState
local State = {
    bootstrapped = false,
    started = false,
}

local function build_sink()
    return {
        emit = Bus.emit,
        compose_key = Bus.compose_key,
    }
end

---@param opts MessageBootstrapOpt|nil
function M.bootstrap(opts)
    if State.bootstrapped then
        return
    end

    opts = opts or {}
    Bus.init(opts.bus)

    local sink = build_sink()

    if opts.history == nil or opts.history.enabled ~= false then
        -- History is independent from the UI renderer.
        require('abel.util.ui.message.history').setup(opts.history)
    end

    if opts.notify == nil or opts.notify.enabled ~= false then
        require('abel.util.ui.message.notify').setup(sink, opts.notify)
    end

    if opts.nvim == nil or opts.nvim.enabled ~= false then
        require('abel.util.ui.message.nvim').setup(sink, opts.nvim)
    end

    State.bootstrapped = true
end

---@param opts MessageStartOpt
function M.start(opts)
    opts = opts or {}

    if not State.bootstrapped then
        M.bootstrap()
    end

    if State.started then
        return
    end

    local subscribers = vim.deepcopy(opts.subscribers or {})
    local bus_backend = opts.bus_backend

    if opts.minimal_renderer ~= false then
        -- Default renderer: live toast windows for message traffic.
        local render = require 'abel.util.ui.message.render'
        local default_id = 'abel-message-render'
        table.insert(subscribers, render.subscriber(default_id, {
            exact = { 'notify', 'msg.clear' },
            prefix = { 'msg.show.' },
        }, vim.log.levels.TRACE))
        bus_backend = bus_backend or default_id
    end

    if opts.history == nil or opts.history.enabled ~= false then
        -- Recorder: same message stream, but only to persist history entries.
        local recorder = require 'abel.util.ui.message.history'
        table.insert(subscribers, recorder.subscriber('abel-message-history', {
            exact = { 'notify', 'msg.clear' },
            prefix = { 'msg.show.' },
        }, vim.log.levels.TRACE))
    end

    assert(type(bus_backend) == 'string' and bus_backend ~= '', 'message.start(opts): bus_backend is required when no default renderer is enabled')

    Bus.start {
        subscribers = subscribers,
        bus_backend = bus_backend,
    }

    State.started = true
end

---@param opts MessageSetupOpt
function M.setup(opts)
    opts = opts or {}
    M.bootstrap {
        bus = opts.bus,
        history = opts.history,
        nvim = opts.nvim,
        notify = opts.notify,
    }
    M.start {
        subscribers = opts.subscribers or {},
        bus_backend = opts.bus_backend,
        minimal_renderer = opts.minimal_renderer,
    }
end

---@return table
function M.get_bus()
    return Bus
end

---@return MessageRuntimeState
function M.status()
    return vim.deepcopy(State)
end

return M
