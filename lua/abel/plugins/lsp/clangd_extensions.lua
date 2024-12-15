local custom = require 'abel.config.custom'

---@type LazyPluginSpec
return {
    'p00f/clangd_extensions.nvim',
    ft = {
        'c',
        'cpp',
        'cxx',
    },

    config = function()
        require('clangd_extensions').setup {
            memory_usage = {
                border = custom.border,
            },
            symbol_info = {
                border = custom.border,
            },
        }

        local group = vim.api.nvim_create_augroup('clangd_extensions', { clear = true })

        vim.api.nvim_create_autocmd('Filetype', {
            group = group,
            desc = 'Setup clangd_extensions scores for cmp',
            pattern = 'c,cpp,cxx',
            callback = function()
                local cmp = require 'cmp'
                cmp.setup.buffer {
                    ---@diagnostic disable-next-line: missing-fields
                    sorting = {
                        comparators = {
                            cmp.config.compare.offset,
                            cmp.config.compare.exact,
                            cmp.config.compare.recently_used,
                            require 'clangd_extensions.cmp_scores',
                            cmp.config.compare.kind,
                            cmp.config.compare.sort_text,
                            cmp.config.compare.length,
                            cmp.config.compare.order,
                        },
                    },
                }
            end,
        })

        vim.api.nvim_create_autocmd('LspAttach', {
            group = group,
            desc = 'Setup clangd_extesnion keymap for cmp',
            callback = function(args)
                local bufnr = args.buf
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client == nil or client.name ~= 'clangd' then
                    return
                end
                vim.keymap.set('n', '<leader>ct', '<Cmd>ClangdAST<CR>', { buffer = bufnr, desc = 'Show AST' })
                vim.keymap.set('n', '<leader>c<leader>', '<Cmd>ClangdSwitchSourceHeader<CR>', { buffer = bufnr, desc = 'Switch between source and header' })
                vim.keymap.set('n', '<leader>h', '<Cmd>ClangdTypeHierarchy<CR>', { buffer = bufnr, desc = 'Show type hierarchy' })
                vim.keymap.set('n', '<leader>m', '<Cmd>ClangdMemoryUsage<CR>', { buffer = bufnr, desc = 'Clangd memory usage' })
            end,
        })
    end,
}
