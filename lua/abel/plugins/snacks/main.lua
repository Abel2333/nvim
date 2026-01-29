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
            size = 1.5 * 1024 * 1024, -- 15 MB
        },
        quickfile = { enabled = true },
        input = {
            icon = ' ',
            icon_hl = 'SnacksInputIcon',
            icon_pos = 'left',
            prompt_pos = 'title',
            win = { style = 'input' },
            expand = true,
        },
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
        ---@class snacks.lazygit.Config: snacks.terminal.Opts
        lazygit = {
            configure = true,
            win = {
                style = 'lazygit',
            },
        },
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
            -- top_down = false,
        },
        explorer = { enabled = false },
    },
    keys = {

        {
            '<leader>pl',
            function()
                Snacks.lazygit()
            end,
            desc = 'LazyGit',
        },
    },
}
