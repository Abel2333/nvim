local misc_util = require 'abel.util.core.misc'

local M = {}

M.init = function()
    M.log_file = vim.fn.stdpath 'data' .. '/abel_log.log'
    local file = io.open(M.log_file, 'a')

    if not file then
    else
        file:close()
    end
end

---@param level 'info' | 'warn' | 'error'
---@param message string
M.print = function(level, message)
    local file = io.open(M.log_file, 'a')

    local time_stamp = os.date '%Y-%m-%d %H:%M:%S'

    if file then
        file:write(string.format('[%s %s] %s', string.upper(level), time_stamp, message))
        file:close()
    else
        misc_util.err('Could not create log file', { title = 'Abel Log' })
    end
end

return M
