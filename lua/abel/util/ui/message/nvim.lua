--------------------------------------------------------------------------------
-- Neovim UI message adapter
-- Adapted from aurora0x27/nvim-config.
--------------------------------------------------------------------------------
local M = {}

---@class MessageSink
---@field emit fun(opts: BusEmitOpt): integer
---@field compose_key fun(namespace: string, raw_id: integer|string): string

---@class MessageNvimOpt
---@field enabled? boolean
---@field ext_messages? boolean

local State = {
    installed = false,
    ns = nil,
}

---@param chunks table[]
---@return string
local function flatten_chunks(chunks)
    if type(chunks) ~= 'table' then
        return ''
    end
    local parts = {}
    for _, chunk in ipairs(chunks) do
        local text = chunk[2]
        if type(text) == 'string' then
            parts[#parts + 1] = text
        end
    end
    return table.concat(parts)
end

---@param kind string
---@return integer
local function level_from_kind(kind)
    local map = {
        emsg = vim.log.levels.ERROR,
        lua_error = vim.log.levels.ERROR,
        rpc_error = vim.log.levels.ERROR,
        echoerr = vim.log.levels.ERROR,
        wmsg = vim.log.levels.WARN,
        echo = vim.log.levels.INFO,
        echomsg = vim.log.levels.INFO,
        lua_print = vim.log.levels.INFO,
        progress = vim.log.levels.INFO,
        verbose = vim.log.levels.DEBUG,
    }
    return map[kind] or vim.log.levels.INFO
end

---@param sink MessageSink
---@param kind string
---@param content table
---@param replace_last boolean
---@param history boolean
---@param append boolean
---@param id integer|string|nil
---@param trigger string
local function on_msg_show(sink, kind, content, replace_last, history, append, id, trigger)
    local key = nil
    local mode = 'new'

    if id ~= nil and (type(id) == 'string' or type(id) == 'number') then
        key = sink.compose_key('nvim.msg', id)
    end

    if append then
        mode = 'append'
    elseif replace_last then
        mode = 'replace'
    end

    sink.emit {
        key = key,
        mode = mode,
        tag = 'msg.show.' .. (kind ~= '' and kind or 'unknown'),
        level = level_from_kind(kind),
        source = 'nvim.ui',
        source_id = id,
        text = flatten_chunks(content),
        content = content,
        meta = {
            kind = kind,
            replace_last = replace_last,
            history = history,
            append = append,
            trigger = trigger,
        },
    }
end

---@param sink MessageSink
local function on_msg_clear(sink)
    sink.emit {
        mode = 'clear',
        tag = 'msg.clear',
        level = vim.log.levels.INFO,
        source = 'nvim.ui',
        text = '',
        content = nil,
        meta = {
            scope = 'messages',
        },
    }
end

---@param sink MessageSink
---@param opts MessageNvimOpt|nil
function M.setup(sink, opts)
    if State.installed then
        return
    end

    opts = opts or {}
    if opts.ext_messages == false then
        return
    end

    local ns = vim.api.nvim_create_namespace 'AbelMessageAdapter'
    State.ns = ns

    vim.ui_attach(ns, { ext_messages = true }, function(event, ...)
        if event == 'msg_show' then
            on_msg_show(sink, ...)
        elseif event == 'msg_clear' then
            on_msg_clear(sink)
        end
        return true
    end)

    State.installed = true
end

return M
