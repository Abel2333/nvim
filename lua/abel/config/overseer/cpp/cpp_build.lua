local misc_utils = require 'abel.util.core.misc'

---@param compiler 'g++' | 'clang++'
local build_single = function(compiler)
    return function()
        local exe_suffix = misc_utils.is_win() and '.exe' or ''

        return {
            name = 'Compile ' .. vim.fn.expand '%:t',
            cmd = { compiler },
            args = {
                '-g',
                '-O0',
                '-std=c++17',
                compiler == 'clang++' and '-fno-limit-debug-info' or '',
                compiler == 'clang++' and '-fstandalone-debug' or '',
                vim.fn.expand '%:p',
                '-o',
                vim.fn.expand '%:p:t:r' .. exe_suffix,
            },
            components = {
                {
                    'on_output_parse',
                    problem_matcher = {
                        fileLocation = { 'autoDetect', '${cwd}' },
                        pattern = {
                            regexp = '^(.*):(\\d+):(\\d+):\\s+(warning|error):\\s+(.*)$',
                            file = 1,
                            line = 2,
                            column = 3,
                            severity = 4,
                            message = 5,
                        },
                    },
                },
                { 'on_output_quickfix', open_on_exit = 'failure' },
                { 'open_output', focus = true, on_result = 'if_diagnostics' },
                { 'on_result_diagnostics', remove_on_restart = true },
                'default',
            },
        }
    end
end

return {
    {
        name = 'Clang Build',
        builder = build_single 'clang++',
        condition = {
            filetype = { 'cpp' },
            callback = function()
                return misc_utils.has_software 'clang'
            end,
        },
    },
    {
        name = 'GCC Build',
        builder = build_single 'g++',
        condition = {
            filetype = { 'cpp' },
            callback = function()
                return misc_utils.has_software 'gcc'
            end,
        },
    },
    {
        name = 'Clang Temp Cleanup',
        builder = function()
            local base = vim.fn.expand '%:p:r'
            return {
                name = 'Remove Compile Temporary File',
                cmd = { 'rm' },
                args = {
                    base .. '.ilk',
                    base .. '.pdb',
                },
            }
        end,
        condition = {
            filetype = { 'cpp' },
            callback = function()
                return misc_utils.is_win() -- Windows only
            end,
        },
    },
}
