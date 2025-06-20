local M = {}
local misc_util = require 'abel.util.misc'

M.adapters = function()
    local isDetached = misc_util.is_linux()

    return {
        gdb = {
            type = 'executable',
            command = 'gdb',
            args = { '--interpreter=dap', '--eval-command', 'set print pretty on' },
        },

        codelldb = {
            type = 'server',
            port = '${port}',
            executable = {
                command = vim.fn.exepath 'codelldb',
                args = {
                    '--port',
                    '${port}',
                    '--settings',
                    vim.json.encode { showDisassembly = 'never' },
                },

                -- On windows you may have to uncomment this:
                detached = isDetached,
            },
        },
        cppdbg = {
            id = 'cppdbg',
            type = 'executable',
            command = vim.fn.exepath 'OpenDebugAD7',
            options = {
                detached = isDetached,
            },
        },
    }
end

M.configurations = {
    cpp = {
        {
            name = 'Launch (CodeLLDB) - Clang',
            type = 'codelldb',
            request = 'launch',
            program = function()
                -- Automatically point to the compilation output
                return vim.fn.expand '%:p:r'
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            preLaunchTask = 'Clang Build',
        },
        {
            name = 'Launch (CppTools) - GCC',
            type = 'cppdbg',
            request = 'launch',
            program = function()
                return vim.fn.expand '%:p:r'
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = true,
            preLaunchTask = 'GCC Build',
        },
        {
            name = 'Launch (gdb)',
            type = 'gdb',
            request = 'launch',
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopAtBeginningOfMainSubprogram = false,
        },
    },
}

M.configurations.c = M.configurations.cpp
M.configurations.rust = M.configurations.cpp

return M
