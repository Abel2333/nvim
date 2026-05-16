--------------------------------------------------------------------------------
-- vim.notify adapter
--------------------------------------------------------------------------------
local M = {}

---@class MessageSink
---@field emit fun(opts: BusEmitOpt): integer
---@field compose_key fun(namespace: string, raw_id: integer|string): string

---@class MessageNotifyOpt
---@field enabled? boolean
---@field title_default? string

local State = {
    installed = false,
    original = nil,
}

---@param sink MessageSink
---@param opts MessageNotifyOpt|nil
function M.setup(sink, opts)
    if State.installed then
        return
    end

    opts = opts or {}
    State.original = vim.notify

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.notify = function(msg, level, notify_opts)
        notify_opts = notify_opts or {}
        local source_id = notify_opts.id
        local key = nil
        local mode = 'new'

        if source_id ~= nil and (type(source_id) == 'string' or type(source_id) == 'number') then
            key = sink.compose_key('notify', source_id)
            mode = 'replace'
        end

        sink.emit {
            key = key,
            mode = mode,
            tag = 'notify',
            level = level or vim.log.levels.INFO,
            source = 'vim.notify',
            source_id = source_id,
            text = tostring(msg or ''),
            content = tostring(msg or ''),
            meta = vim.tbl_extend('force', {
                title = notify_opts.title or opts.title_default or 'Notify',
            }, notify_opts),
        }
    end

    State.installed = true
end

---@return function|nil
function M.get_original()
    return State.original
end

return M
