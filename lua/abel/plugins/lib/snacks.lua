---A collection of small QoL plugins for Neovim
---@type LazyPluginSpec
return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        bigfile = {
            enabled = true,
            size = 15 * 1024 * 1024, -- 15 MB
        },
        quickfile = { enabled = true },
        input = { enabled = false },
        indent = {
            enabled = true,
            priority = 1,
            char = '│', -- Suitable for snacks.indent
            -- char = '▏', -- Thiner, not suitable when enable scope
            chunk = {
                enabled = true,
                char = {
                    corner_top = '╭',
                    corner_bottom = '╰',
                },
            },
        },
        ---@class snacks.picker.Config
        picker = {},
        ---@class snacks.notifier.Config
        notifier = {
            timeout = 3000,
            width = { min = 30, max = 0.75 },
            height = { min = 1, max = 0.6 },
            icons = {
                error = ' ',
                warn = ' ',
                info = ' ',
                debug = ' ',
                trace = ' ',
            },
        },
        explorer = {},
        image = { force = true },
    },
    ---@class Snacks: snacks.plugins
    keys = {

        -- Top Pickers & Explorer
        {
            '<leader>ff',
            function()
                Snacks.picker.smart()
            end,
            desc = 'Files',
        },
        {
            '<leader>fr',
            function()
                Snacks.picker.recent()
            end,
            desc = 'Recent Files',
        },
        {
            '<leader>fb',
            function()
                Snacks.picker.buffers()
            end,
            desc = 'Buffers',
        },
        {
            '<leader>fw',
            function()
                Snacks.picker.grep()
            end,
            desc = 'Grep',
        },
        {
            '<leader>f:',
            function()
                Snacks.picker.command_history()
            end,
            desc = 'Command History',
        },
        {

            '<leader>fh',
            function()
                Snacks.picker.notifications()
            end,
            desc = 'Notification History',
        },
        {
            '<leader>fe',
            function()
                Snacks.explorer()
            end,
            desc = 'File Explorer',
        },

        -- find
        {
            '<leader>fc',
            function()
                ---@diagnostic disable-next-line: assign-type-mismatch
                Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
            end,
            desc = 'Find Config File',
        },

        -- search
        {
            '<leader>f?',
            function()
                Snacks.picker.help()
            end,
            desc = 'Help Pages',
        },
        {
            '<leader>fH',
            function()
                Snacks.picker.highlights()
            end,
            desc = 'Highlights',
        },
        {
            '<leader>fj',
            function()
                Snacks.picker.jumps()
            end,
            desc = 'Jumps',
        },
        {
            '<leader>fk',
            function()
                Snacks.picker.keymaps()
            end,
            desc = 'Keymaps',
        },
        {
            '<leader>fd',
            function()
                Snacks.picker.diagnostics()
            end,
            desc = 'Diagnostics',
        },

        -- git
        {
            '<leader>fgb',
            function()
                Snacks.picker.git_branches()
            end,
            desc = 'Git Branches',
        },
        {
            '<leader>fgl',
            function()
                Snacks.picker.git_log()
            end,
            desc = 'Git Log',
        },
        {
            '<leader>fgL',
            function()
                Snacks.picker.git_log_line()
            end,
            desc = 'Git Log Line',
        },
        {
            '<leader>fgs',
            function()
                Snacks.picker.git_status()
            end,
            desc = 'Git Status',
        },
        {
            '<leader>fgS',
            function()
                Snacks.picker.git_stash()
            end,
            desc = 'Git Stash',
        },
        {
            '<leader>fgd',
            function()
                Snacks.picker.git_diff()
            end,
            desc = 'Git Diff (Hunks)',
        },
        {
            '<leader>fgf',
            function()
                Snacks.picker.git_log_file()
            end,
            desc = 'Git Log File',
        },
    },
}
