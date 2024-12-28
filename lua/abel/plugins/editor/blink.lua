local custom = require 'abel.config.custom'

---@type LazyPluginSpec
return {
    ---@module 'blink.cmp'
    'Saghen/blink.cmp',

    dependencies = {
        'rafamadriz/friendly-snippets',
        'L3MON4D3/LuaSnip',
    },

    -- NOTE: Request rust nightly
    build = 'cargo build --release',
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = 'default',
            ['<C-space>'] = {},
            ['<C-e>'] = {
                'hide',
                'show',
            },
            ['<Tab>'] = {},
            ['<S-Tab>'] = {},
            ['<C-l>'] = { 'snippet_forward', 'fallback' },
            ['<C-h>'] = { 'snippet_backward', 'fallback' },
        },
        snippets = {
            expand = function(snippet)
                require('luasnip').lsp_expand(snippet)
            end,
            active = function(filter)
                if filter and filter.direction then
                    return require('luasnip').jumpable(filter.direction)
                end
                return require('luasnip').in_snippet()
            end,
            jump = function(direction)
                require('luasnip').jump(direction)
            end,
        },
        sources = {
            default = {
                'lsp',
                'path',
                'luasnip',
                'buffer',
                'lazydev',
            },
            providers = {
                lsp = {
                    name = 'LSP',
                    fallbacks = {
                        'lazydev',
                    },
                },
                lazydev = {
                    name = 'Development',
                    module = 'lazydev.integrations.blink',
                },
            },
        },
        completion = {
            ghost_text = { enabled = true },
            list = {
                selection = function(ctx)
                    return ctx.mode == 'cmdline' and 'auto_insert' or 'preselect'
                end,
            },
            menu = {
                border = 'rounded',
                -- Minimum width should be controlled by components
                min_width = 1,
                draw = {
                    columns = {
                        { 'kind_icon' },
                        { 'label', 'label_description', gap = 1 },
                        { 'provider' },
                    },
                    components = {
                        provider = {
                            text = function(ctx)
                                return '[' .. ctx.item.source_name:sub(1, 3):upper() .. ']'
                            end,
                        },
                    },
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 0,
                update_delay_ms = 0,
                window = {
                    border = 'rounded',
                    winblend = vim.o.pumblend,
                },
            },
        },
        appearance = {
            nerd_font_variant = 'mono',
            kind_icons = custom.icons.kind,
        },
    },
}
