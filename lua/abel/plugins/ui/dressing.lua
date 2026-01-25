local custom = require 'abel.config.custom'

return {
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
    enabled = false,
    opts = {
        input = {
            border = 'rounded',
        },
        select = {
            backend = { 'fzf_lua', 'telescope', 'fzf', 'builtin', 'nui' },
            builtin = {
                border = custom.border,
            },
            fzf_lua = {
                winopts = {
                    height = 0.4,
                },
            },
        },
    },
}
