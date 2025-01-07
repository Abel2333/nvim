---A collection of small QoL plugins for Neovim
---@type LazyPluginSpec
return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        bigfile = { enabled = true },
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
    },
}
