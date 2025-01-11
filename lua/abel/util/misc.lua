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

---Log
---@param massage string
function M.log(massage)
    local log_file = vim.fn.stdpath 'data' .. '/abel_log.log'

    local file = io.open(log_file, 'a')

    if file then
        local time_stamp = os.date '%Y-%m-%d %H:%M:%S'

        file:write(string.format('[%s] %s\n', time_stamp, massage))

        file:close()
    else
        M.err('Could not create log file', { title = 'Abel Log' })
    end
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

---Do an async task
---@param command string
---@param owner string
function M.async_task(command, owner)
    M.info('Start command', { title = owner })

    M.log 'Command start: '
    M.log(command)
    local handle = vim.fn.jobstart(command, {
        -- Callback
        on_stdout = function(_, data, _)
            if data then
                M.log(table.concat(data, '\n'))
            end
        end,
        on_stderr = function(_, data, _)
            if data then
                local stderr_output = table.concat(data, '\n')
                M.log(stderr_output)
                if string.find(stderr_output, 'error') then
                    M.err('Install websocat failed', { title = 'typst-preview' })
                end
            end
        end,
        on_exit = function(_, exit_code, _)
            M.log('Install websocat end with ' .. exit_code)
            M.info('Install websocat end with ' .. exit_code, { title = 'typst-preview' })
        end,
    })

    -- Control the task by this handle
    return handle
end

return M
