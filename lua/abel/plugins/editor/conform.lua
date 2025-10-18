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
            markdown = { 'prettier' },
            json = { 'prettier' },
            css = { 'prettier' },
            cs = { 'csharpier' },
            typst = { 'typstyle', lsp_format = 'prefer' },
            latex = { 'tex-fmt' },
            rust = { 'rustfmt' },
            toml = { 'pyproject-fmt', 'tombi' },
        },
        formatters = {
            csharpier = {
                command = 'dotnet-csharpier',
                args = { '--write-stdout' },
            },
        },
    },
}
