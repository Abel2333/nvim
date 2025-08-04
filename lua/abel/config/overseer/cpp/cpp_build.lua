local misc_utils = require 'abel.util.misc'

---@param compiler 'g++' | 'clang++'
local build_single = function(compiler)
    return function()
        local exe_suffix = misc_utils.is_win() and '.exe' or ''

        return {
            cmd = { compiler },
            args = {
                '-g',
                '-std=c++17',
                vim.fn.expand '%:p',
                '-o',
                vim.fn.expand '%:p:t:r' .. exe_suffix,
            },
            components = {
                { 'on_output_quickfix', open_on_exit = 'failure' },
                {
                    'on_output_parse',
                    problem_matcher = {
                        {
                            owner = 'cpp',
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
                },
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
