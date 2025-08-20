---@type LazyPluginSpec
return {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'VeryLazy',
    enabled = false,
    priority = 1000,
    opts = {
        preset = 'ghost',
        options = {
            show_source = {
                enabled = true,
                if_many = false,
            },
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
