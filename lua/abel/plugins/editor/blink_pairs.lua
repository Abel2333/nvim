---@type LazyPluginSpec
return {
    'saghen/blink.pairs',
    version = '*', -- (recommended) only required with prebuilt binaries
    event = { 'BufReadPost', 'BufNewFile' },
    enabled = false,

    build = 'cargo build --release',
    --- @module 'blink.pairs'
    --- @type blink.pairs.Config
    opts = {
        mappings = {
            enabled = true,
            disabled_filetypes = {},
            pairs = {},
        },
        highlights = {
            enabled = true,
            groups = {
                'BlinkPairsOrange',
                'BlinkPairsPurple',
                'BlinkPairsBlue',
            },

            -- highlights matching pairs under the cursor
            matchparen = {
                enabled = true,
                -- known issue where typing won't update matchparen highlight, disabled by default
                group = 'BlinkPairsMatchParen',
            },
        },
        debug = false,
    },
}
