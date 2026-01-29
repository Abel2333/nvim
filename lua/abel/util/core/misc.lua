local M = {}

function M.is_win()
    return vim.uv.os_uname().sysname:find 'Windows' ~= nil
end

function M.is_linux()
    return vim.uv.os_uname().sysname:find 'Linux' ~= nil
end

---@param plugin string
function M.has_plugin(plugin)
    return require('lazy.core.config').spec.plugins[plugin] ~= nil
end

---@param software string
function M.has_software(software)
    local state_code = vim.fn.executable(software)
    return state_code == 1
end

---Send notify
---@param massage string
---@param opts table
function M.info(massage, opts)
    vim.notify(massage, vim.log.levels.INFO, opts)
end

---@param massage string
---@param opts table
function M.warn(massage, opts)
    vim.notify(massage, vim.log.levels.WARN, opts)
end

---@param massage string
---@param opts table
function M.err(massage, opts)
    vim.notify(massage, vim.log.levels.ERROR, opts)
end

---Turn the first letter of a string to uppercase
---@param str string
---@return string uppercased
function M.firstToUpper(str)
    return (str:gsub('^%l', string.upper))
end

-- FFI
local ffi = require 'abel.util.core.ffidef'
local error = ffi.new 'Error'

---@param winid number
---@param lnum number
---@return foldinfo_T | nil
function M.fold_info(winid, lnum)
    local win_T_ptr = ffi.C.find_window_by_handle(winid, error)
    if win_T_ptr == nil then
        return
    end
    return ffi.C.fold_info(win_T_ptr, lnum)
end

---Set the indent option
---@param scope "global" | "local"
function M.set_breakindentopt(scope)
    local identvalue = vim.o.expandtab and vim.o.shiftwidth or vim.o.tabstop
    vim.api.nvim_set_option_value('breakindentopt', 'shift:' .. identvalue, { scope = scope })
end

return M
