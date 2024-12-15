---@type LazyPluginSpec
return {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    main = 'ibl',
    opts = {
        indent = {
            char = '▏', -- Thiner, not suitable when enable scope
            tab_char = '▏',
        },
        scope = {
            enabled = false,
        },
        exclude = {
            filetypes = {
                'help',
                'alpha',
                'dashboard',
                'neo-tree',
                'Trouble',
                'trouble',
                'lazy',
                'mason',
                'notify',
                'toggleterm',
                'lazyterm',
            },
        },
    },
}
