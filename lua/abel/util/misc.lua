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
local ffi = require 'abel.util.ffidef'
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

---Move selected block up or down
---@param direction "up"|"down"
function M.move_block(direction)
    -- Get the start and the end of visual mode
    local vstart = vim.fn.getpos 'v'
    local vend = vim.fn.getcurpos()

    -- The start and end of visual mode are determined by
    -- the direction of the selection process.
    local start_line = math.min(vstart[2], vend[2])
    local end_line = math.max(vstart[2], vend[2])

    if direction == 'down' then
        if end_line == vim.api.nvim_buf_line_count(0) then
            M.info('This is the last line of buf', { title = 'Move down' })
            return
        end
        vim.cmd(start_line .. ',' .. end_line .. 'move ' .. end_line .. '+1')
    elseif direction == 'up' then
        if start_line == 1 then
            M.info('This is the first line of buf', { title = 'Move up' })
            return
        end
        vim.cmd(start_line .. ',' .. end_line .. 'move' .. start_line .. '-2')
    end

    -- \27 refer <Esc> in ASCII code
    vim.api.nvim_feedkeys('\27', '!', true)

    if direction == 'down' then
        vim.api.nvim_feedkeys(start_line + 1 .. 'GV' .. end_line + 1 .. 'G', '!', true)
    elseif direction == 'up' then
        vim.api.nvim_feedkeys(start_line - 1 .. 'GV' .. end_line - 1 .. 'G', '!', true)
    end
end

---Set the indent option
---@param scope "global" | "local"
function M.set_breakindentopt(scope)
    local identvalue = vim.o.expandtab and vim.o.shiftwidth or vim.o.tabstop
    vim.api.nvim_set_option_value('breakindentopt', 'shift:' .. identvalue, { scope = scope })
end

return M
