local custom = require 'abel.config.custom'

---@type LazyPluginSpec
return {
    'rcarriga/nvim-dap-ui',
    opts = {
        floating = {
            border = custom.border,
        },
        icons = { collapsed = '', current_frame = '', expanded = '' },
        layouts = {
            {
                elements = {
                    {
                        id = 'scopes',
                        size = 0.25,
                    },
                    {
                        id = 'breakpoints',
                        size = 0.25,
                    },
                    {
                        id = 'stacks',
                        size = 0.25,
                    },
                    {
                        id = 'watches',
                        size = 0.25,
                    },
                },
                position = 'left',
                size = 30,
            },
            {
                elements = {
                    {
                        id = 'repl',
                        size = 0.5,
                    },
                    {
                        id = 'console',
                        size = 0.5,
                    },
                },
                position = 'bottom',
                size = 10,
            },
        },
        mappings = {
            edit = 'i',
            expand = { 'o', '<LeftMouse>' },
            open = { '<CR>', '<2-LeftMouse>' },
            remove = 'd',
            repl = 'r',
            toggle = 't',
        },
    },
    keys = {
        {
            '<leader>du',
            function()
                require('dapui').toggle()
            end,
            desc = 'Toggle full UI',
        },
        {
            '<M-k>',
            function()
                require('dapui').eval()
            end,
            desc = 'Evaluate Expression',
            mode = { 'n', 'v' },
        },
        {
            '<leader>ds',
            function()
                require('dapui').float_element('stacks', {
                    title = 'Stacks',
                    width = 60,
                    height = 20,
                    enter = true,
                    position = 'center',
                })
            end,
            desc = 'Open Stacks',
        },
        {
            '<leader>dw',
            function()
                require('dapui').float_element('watches', {
                    title = 'Watches',
                    width = 60,
                    height = 20,
                    enter = true,
                    position = 'center',
                })
            end,
            desc = 'Open Watches',
        },
        {
            '<leader>dv',
            function()
                require('dapui').float_element('scopes', {
                    title = 'Scopes',
                    width = 60,
                    height = 20,
                    enter = true,
                    position = 'center',
                })
            end,
            desc = 'Open Scopes',
        },
        {
            '<leader>db',
            function()
                require('dapui').float_element('breakpoints', {
                    title = 'BreakPoints',
                    width = 60,
                    height = 20,
                    enter = true,
                    position = 'center',
                })
            end,
            desc = 'Open BreakPoints',
        },
        {
            '<leader>dc',
            function()
                require('dapui').float_element('console', {
                    title = 'Console',
                    width = 60,
                    height = 20,
                    enter = true,
                    position = 'center',
                })
            end,
            desc = 'Open Console',
        },
        {
            '<leader>dr',
            function()
                require('dapui').float_element('repl', {
                    title = 'Repl',
                    width = 60,
                    height = 20,
                    enter = true,
                    position = 'center',
                })
            end,
            desc = 'Open Repl',
        },
    },
}
