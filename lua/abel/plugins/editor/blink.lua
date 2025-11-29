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
    version = '1.*',

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
            ['<C-y>'] = {
                'select_and_accept',
                function() -- sidekick next edit suggestion
                    return require('sidekick').nes_jump_or_apply()
                end,
                -- NOTE: The following function is used for Neovim's native inline completions
                -- and need version >= 0.12
                -- function()
                --     return vim.lsp.inline_completion.get()
                -- end,
                'fallback',
            },
            ['<C-l>'] = { 'snippet_forward', 'fallback' },
            ['<C-h>'] = { 'snippet_backward', 'fallback' },
        },
        snippets = { preset = 'luasnip' },
        sources = {
            default = {
                'lsp',
                'path',
                'snippets',
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
                selection = {
                    preselect = function(ctx)
                        return ctx.mode ~= 'cmdline' and not require('blink.cmp').snippet_active { direction = 1 }
                    end,
                },
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
                update_delay_ms = 50,
                window = {
                    border = 'rounded',
                    winblend = vim.o.pumblend,
                },
            },
        },
        signature = {
            enabled = true,
            window = {
                show_documentation = true,
                border = 'rounded',
                winblend = vim.o.pumblend,
            },
        },
        appearance = {
            nerd_font_variant = 'mono',
            kind_icons = custom.icons.kind,
        },
    },
}
