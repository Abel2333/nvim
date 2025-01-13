---@type LazyPluginSpec
return {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'VeryLazy',
    priority = 1000,
    opts = {
        preset = 'ghost',
        options = {
            multilines = {
                enabled = true,
                always_show = false,
            },
            overflow = {
                mode = 'wrap',
            },
        },
        signs = {
            diag = '󰊠 ',
        },
        blend = {
            factor = 0.45,
        },
    },
}
