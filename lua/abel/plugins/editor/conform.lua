---@type LazyPluginSpec
return {
    'stevearc/conform.nvim',
    lazy = true,
    keys = {
        {
            '<leader>F',
            function()
                require('conform').format { async = true, lsp_fallback = true }
            end,
            mode = '',
            desc = 'Format buffer',
        },
    },
    opts = {
        notify_on_error = false,
        format_on_save = function(bufnr)
            -- Disable "format_on_save lsp_fallback" for languages that don't
            -- have a well standardized coding style. You can add additional
            -- languages here or re-enable it for the disabled ones.
            local disable_filetypes = {}
            return {
                timeout_ms = 500,
                lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
            }
        end,
        formatters_by_ft = {
            lua = { 'stylua' },
            -- Conform can also run multiple formatters sequentially
            python = { 'black' },
            --
            -- You can use a sub-list to tell conform to run *until* a formatter
            -- is found.
            javascript = { { 'prettierd', 'prettier' } },
            cpp = { 'clangd-format' },
            cmake = { 'cmake_format' },
            json = { 'biome' },
            cs = { 'csharpier' },
            css = { 'prettier' },
            typst = { 'typstyle', lsp_format = 'prefer' },
            latex = { 'tex-fmt' },
        },
        formatters = {
            csharpier = {
                command = 'dotnet-csharpier',
                args = { '--write-stdout' },
            },
        },
    },
}
