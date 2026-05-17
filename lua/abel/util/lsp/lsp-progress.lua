-- LSP progress notifications
-- Tracks progress per-client and renders a single aggregated notify

---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
local toast = require 'abel.util.ui.toast'

-- Spinner glyphs used while progress is active
local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
local REFRESH_DELAY_MS = 50
local refresh_timers = {}

--------------------------------------------------------------------------------
-- Utility Functions
--------------------------------------------------------------------------------

---Return a consistent progress message for a single LSP progress value
---@param value {percentage?: number, title?: string, message?: string, kind: "begin"|"report"|"end"}
---@return string
local function build_msg(value)
    return ('[%3d%%] %s%s'):format(
        value.kind == 'end' and 100 or value.percentage or 100,
        value.title or '',
        value.message and (' **%s**'):format(value.message) or ''
    )
end

---Compute spinner icon based on current time and progress state
---@param client_id number
---@return string
local function get_icon(client_id)
    if #progress[client_id] == 0 then
        return ' '
    end
    local idx = math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1
    return spinner[idx]
end

---@param timer uv.uv_timer_t|nil
local function stop_timer(timer)
    if not timer then
        return
    end
    pcall(timer.stop, timer)
    pcall(timer.close, timer)
end

---@param client_id number
local function render_progress(client_id)
    local client = vim.lsp.get_client_by_id(client_id)
    local p = progress[client_id]
    if not client or not p then
        return
    end

    local msg = {} ---@type string[]
    for _, v in ipairs(p) do
        if not v.done then
            msg[#msg + 1] = v.msg
        end
    end

    if #msg == 0 then
        toast.dismiss('lsp_progress:' .. client.id)
        return
    end

    toast.show(table.concat(msg, '\n'), {
        id = 'lsp_progress:' .. client.id,
        title = client.name,
        icon = get_icon(client.id),
        channel = 'progress',
        relayout = true,
        size = {
            width = { min = 30, max = 0.75 },
            height = { min = 1, max = 0.6 },
        },
    })
end

---@param client_id number
local function schedule_refresh(client_id)
    local timer = refresh_timers[client_id]
    if not timer then
        timer = assert(vim.uv.new_timer())
        refresh_timers[client_id] = timer
    else
        pcall(timer.stop, timer)
    end

    timer:start(REFRESH_DELAY_MS, 0, vim.schedule_wrap(function()
        if timer:is_closing() then
            return
        end
        refresh_timers[client_id] = nil
        stop_timer(timer)
        render_progress(client_id)
    end))
end

--------------------------------------------------------------------------------
-- Handler
--------------------------------------------------------------------------------

---Process a single LspProgress event
---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
local function on_progress(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= 'table' then
        return
    end

    local p = progress[client.id]
    for i = 1, #p + 1 do
        if i == #p + 1 or p[i].token == ev.data.params.token then
            p[i] = {
                token = ev.data.params.token,
                msg = build_msg(value),
                done = value.kind == 'end',
            }
            break
        end
    end

    local active = {} ---@type {token:lsp.ProgressToken, msg:string, done:boolean}[]
    for _, v in ipairs(p) do
        if not v.done then
            active[#active + 1] = v
        end
    end
    progress[client.id] = active

    schedule_refresh(client.id)
end

--------------------------------------------------------------------------------
-- Setup
--------------------------------------------------------------------------------

local function apply()
    vim.api.nvim_create_autocmd('LspProgress', {
        callback = on_progress,
    })

    -- Clean the progress table when Lsp Detach
    vim.api.nvim_create_autocmd('LspDetach', {
        callback = function(ev)
            progress[ev.data.client_id] = nil
        end,
    })
end

return { apply = apply }
