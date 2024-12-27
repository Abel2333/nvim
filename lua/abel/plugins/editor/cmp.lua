---Autocompletion

local custom = require 'abel.config.custom'

---@type LazyPluginSpec
return {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    enabled = false,
    dependencies = {
        {
            'L3MON4D3/LuaSnip',
        },
        { 'saadparwaiz1/cmp_luasnip' },

        { 'hrsh7th/cmp-calc' },
        { 'hrsh7th/cmp-path' },
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-cmdline' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-nvim-lsp-signature-help' },
        { 'onsails/lspkind-nvim' },
        { 'kristijanhusak/vim-dadbod-completion' },
        { 'lukas-reineke/cmp-under-comparator' },
    },
    opts = function()
        local cmp = require 'cmp'
        local luasnip = require 'luasnip'
        local lspkind = require 'lspkind'

        return {
            ---@type cmp.ConfigSchema
            global = {
                completion = {
                    completeopt = vim.o.completeopt,
                },
                window = {
                    completion = {
                        border = custom.border,
                    },
                    documentation = {
                        border = custom.border,
                    },
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert {
                    -- Select the [n]ext item
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    -- Select the [p]revious item
                    ['<C-p>'] = cmp.mapping.select_prev_item(),

                    -- Scroll the documentation window [b]ack / [f]orward
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),

                    -- Use [y]es to select signal
                    ['<C-y>'] = cmp.mapping.confirm { select = true },

                    -- Manually trigger a completion from nvim-cmp.
                    ['<C-e>'] = cmp.mapping.complete {},

                    -- Set <C-l> as moving to the right of your snippet expansion.
                    -- <C-h> is similar, except moving you backwards.
                    ['<C-l>'] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump(1)
                        end
                    end, { 'i', 's' }),
                    ['<C-h>'] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { 'i', 's' }),
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'path' },
                    {
                        name = 'buffer',
                        option = {
                            get_bufnrs = function()
                                local bufs = {}
                                for _, win in ipairs(vim.api.nvim_list_wins()) do
                                    bufs[vim.api.nvim_win_get_buf(win)] = true
                                end
                                return vim.tbl_keys(bufs)
                            end,
                        },
                    },
                    { name = 'calc' },
                },
                ---@diagnostic disable-next-line: missing-fields
                formatting = {
                    format = lspkind.cmp_format(custom.cmp_format),
                    fields = {
                        'kind',
                        'abbr',
                        'menu',
                    },
                },
                ---@diagnostic disable-next-line: missing-fields
                sorting = {
                    comparators = {
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        -- cmp.config.compare.scopes,
                        cmp.config.compare.score,
                        require('cmp-under-comparator').under,
                        cmp.config.compare.recently_used,
                        cmp.config.compare.locality,
                        cmp.config.compare.kind,
                        -- cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    },
                },
            },
            cmdline = {
                [':'] = {
                    completion = {
                        completeopt = 'menu,menuone,noselect',
                    },
                    sources = cmp.config.sources({
                        { name = 'path' },
                    }, {
                        { name = 'cmdline' },
                    }),
                },
                ['/'] = {
                    completion = {
                        completeopt = 'menu,menuone,noselect',
                    },
                    sources = {
                        { name = 'buffer' },
                    },
                },
            },
        }
    end,
    config = function(_, opts)
        local cmp = require 'cmp'

        cmp.setup.global(opts.global)
        for type, cmdlineopts in pairs(opts.cmdline) do
            cmp.setup.cmdline(type, cmdlineopts)
        end

        -- Add sql support only when open the sql file
        vim.api.nvim_create_autocmd('Filetype', {
            desc = 'Setup cmp buffer sql source',
            pattern = 'sql',
            callback = function()
                cmp.setup.buffer {
                    sources = {
                        { name = 'vim-dadbod-completion' },
                    },
                }
            end,
        })
    end,
}
