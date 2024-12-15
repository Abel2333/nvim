---@type LazyPluginSpec
return {
    'mfussenegger/nvim-dap',
    dependencies = {
        'jay-babu/mason-nvim-dap.nvim',
        'LiadOz/nvim-dap-repl-highlights',
        'theHamsta/nvim-dap-virtual-text',
        'rcarriga/nvim-dap-ui',
    },
    config = function()
        local dap = require 'dap'
        dap.defaults.fallback.external_terminal = {
            command = '/usr/bin/kitty',
            args = {
                '--class',
                'kitty-dap',
                '--hold',
                '--detach',
                'nvim-dap',
                '-c',
                'DAP',
            },
        }

        dap.adapters['nvim-lua'] = function(callback, config)
            callback {
                type = 'server',
                ---@diagnostic disable-next-line: undefined-field
                host = config.host or '127.0.0.1',
                ---@diagnostic disable-next-line: undefined-field
                port = config.port or 8086,
            }
        end

        dap.configurations.lua = {
            {
                type = 'nvim-lua',
                request = 'attach',
                name = 'Attach to running Neovim instance',
            },
        }

        dap.adapters.gdb = {
            type = 'executable',
            command = 'gdb',
            args = { '-i', 'dap' },
        }

        dap.configurations.c = {
            {
                name = 'Launch',
                type = 'gdb',
                request = 'launch',
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fs.joinpath(vim.fn.getcwd() .. 'file'))
                end,
                cwd = '${workspaceFolder}',
                stopAtBeginningOfMainSubprogram = false,
            },
        }

        ---@diagnostic disable-next-line: undefined-field
        require('overseer').enable_dap(true)
        require('dap.ext.vscode').json_decode = require('overseer.json').decode
    end,

    keys = {
        {
            '<F5>',
            function()
                require('dap').continue()
            end,
            desc = 'Debug: Continuew',
        },
        {
            -- '<S-F5>',
            '<F17>', -- Shift + <F5>. 17 = 12 + 5
            function()
                require('dap').terminate()
            end,
            desc = 'Debug: Terminate',
        },
        {
            '<F10>',
            function()
                require('dap').step_over()
            end,
            desc = 'Debug: Step over',
        },
        {
            '<F11>',
            function()
                require('dap').step_into()
            end,
            desc = 'Debug: Step into',
        },
        {
            '<F23>',
            function()
                require('dap').step_out()
            end,
            desc = 'Debug: Step out',
        },
        {
            '<F9>',
            function()
                require('dap').toggle_breakpoint()
            end,
            desc = 'Debug: Toggle breakpoint',
        },
        {
            '<leader>dp',
            function()
                local condition = vim.fn.input 'Breakpoint condition: '
                if condition == '' then
                    return
                end
                require('dap').set_breakpoint(condition)
            end,
            desc = 'Set Condition Breakpoint',
        },
        {
            '<leader>dP',
            function()
                require('dap').repl.toggle()
            end,
            desc = 'Toggle REPL',
        },
        {
            '<leader>dl',
            function()
                require('dap').run_last()
            end,
            desc = 'Run last',
        },
    },
}
