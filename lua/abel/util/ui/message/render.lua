--------------------------------------------------------------------------------
-- Minimal message renderer backed by Abel toast
--------------------------------------------------------------------------------
local toast = require 'abel.util.ui.toast'
local M = {}

---@class MessageRenderOpt
---@field timeout? integer|false Default timeout for transient messages
---@field more_format? string Footer format for truncated messages

local DEFAULT_TIMEOUT = 3000

---@param level integer
---@return AbelNotifyLevel
local function level_to_toast(level)
    if level >= vim.log.levels.ERROR then
        return 'error'
    end
    if level >= vim.log.levels.WARN then
        return 'warn'
    end
    if level >= vim.log.levels.INFO then
        return 'info'
    end
    if level >= vim.log.levels.DEBUG then
        return 'debug'
    end
    return 'trace'
end

---@param msg Message
---@return string
local function render_text(msg)
    if type(msg.text) == 'string' and msg.text ~= '' then
        return msg.text
    end
    if type(msg.content) == 'string' then
        return msg.content
    end
    return vim.inspect(msg.content)
end

---@param msg Message
---@param opts MessageRenderOpt|nil
---@return boolean?
function M.on_message(msg, opts)
    opts = opts or {}

    if msg.mode == 'clear' then
        if msg.source == 'nvim.ui' then
            toast.dismiss 'msg:area'
        elseif msg.key then
            toast.dismiss(msg.key)
        end
        return
    end

    if msg.meta and msg.meta.channel and msg.meta.channel ~= 'message' then
        return
    end

    local title = msg.source
    if type(msg.meta) == 'table' and type(msg.meta.title) == 'string' and msg.meta.title ~= '' then
        title = msg.meta.title
    elseif msg.tag == 'notify' then
        title = 'Notify'
    elseif vim.startswith(msg.tag, 'msg.show.') then
        title = msg.tag:sub(#'msg.show.' + 1)
    end

    local notif_id = msg.key
    if notif_id == nil and msg.source == 'nvim.ui' then
        notif_id = 'msg:area'
    end

    local timeout = opts.timeout
    if msg.mode == 'replace' or msg.mode == 'append' then
        timeout = timeout or false
    else
        timeout = timeout or DEFAULT_TIMEOUT
    end

    toast.notify_like(render_text(msg), {
        id = notif_id,
        title = title,
        timeout = timeout,
        level = level_to_toast(msg.level),
        channel = 'message',
        more_format = opts.more_format or ' +%d more ',
        relayout = msg.mode == 'replace' or msg.mode == 'append',
        size = {
            width = { min = 30, max = 0.75 },
            height = { min = 1, max = 0.6 },
        },
    })
end

---@param id string
---@param interested BusSubscriberInterestedTagDecl
---@param min_level integer|nil
---@param opts MessageRenderOpt|nil
---@return BusSubscriberDecl
function M.subscriber(id, interested, min_level, opts)
    return {
        id = id,
        interested = interested,
        min_level = min_level or vim.log.levels.TRACE,
        handler = function(msg)
            return M.on_message(msg, opts)
        end,
    }
end

return M
