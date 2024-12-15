---@type LazyPluginSpec
return {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
    opts = {
        override_by_extension = {
            ['norg'] = {
                icon = '󱞁',
                color = '#77aa99',
                name = 'Neorg',
            },
        },
    },
}
