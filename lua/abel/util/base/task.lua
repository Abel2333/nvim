local misc_utils = require 'abel.util.core.misc'
local log = require 'abel.util.base.log'

---Do an async task
---@param command string
---@param owner string
local function async_task(command, owner)
    misc_utils.info('Start command', { title = owner })
    log.init()

    log.print('info', 'Command start: ')
    log.print('info', command)
    local handle = vim.fn.jobstart(command, {
        -- Callback
        on_stdout = function(_, data, _)
            if data then
                log.print('info', table.concat(data, '\n'))
            end
        end,
        on_stderr = function(_, data, _)
            if data then
                local stderr_output = table.concat(data, '\n')
                log.print('error', stderr_output)
                if string.find(stderr_output, 'error') then
                    misc_utils.err('Install websocat failed', { title = 'typst-preview' })
                end
            end
        end,
        on_exit = function(_, exit_code, _)
            log.print('info', 'Install websocat end with ' .. exit_code)
            misc_utils.info('Install websocat end with ' .. exit_code, { title = 'typst-preview' })
        end,
    })

    -- Control the task by this handle
    return handle
end

return async_task
