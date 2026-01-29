local misc_utils = require('abel.util.core.misc')

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
            python = function()
                if misc_utils.has_software('ruff') then
                    return { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' }
                else
                    return { 'isort', 'black' }
                end
            end,
            -- You can use a sub-list to tell conform to run *until* a formatter
            -- is found.
            javascript = { { 'prettierd', 'prettier' } },
            cpp = { 'clangd-format' },
            cmake = { 'cmake_format' },
            markdown = { 'prettier' },
            json = { 'prettier' },
            css = { 'prettier' },
            html = { 'prettier' },
            cs = { 'csharpier' },
            -- Conform can also run multiple formatters sequentially
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
