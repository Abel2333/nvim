local dap_configs = require 'abel.config.dap'

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
        local ui = require 'dapui'

        dap.listeners.before.attach.dapui_config = function()
            ui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            ui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            ui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            ui.close()
        end

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

        dap.adapters = dap_configs.adapters()
        dap.configurations = dap_configs.configurations

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
            desc = 'Debug: Continue',
        },
        {
            '<S-F5>',
            -- '<F17>', -- Shift + <F5>. 17 = 12 + 5
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
            '<S-F11>',
            -- '<F23>', -- Shift + <F11>.
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
