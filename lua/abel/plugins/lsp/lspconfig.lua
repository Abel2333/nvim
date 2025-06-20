local custom = require 'abel.config.custom'
local lsp_util = require 'abel.util.lsp'

---@type LazyPluginSpec
return {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = {
        'Filetype',
    },
    dependencies = {
        -- Automatically install LSPs and related tools to stdpath for Neovim
        { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',

        'folke/neoconf.nvim',

        -- Provides the SchemaStore catalog for use with jsonls
        'b0o/schemastore.nvim',

        -- Useful status updates for LSP.
        { 'j-hui/fidget.nvim', opts = {} },

        -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
        -- used for completion, annotations and signatures of Neovim apis
        -- No need for lazydev enabled
        -- { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
        require('lspconfig.ui.windows').default_options.border = custom.border

        lsp_util.config_servers()

        require('mason').setup()
    end,
    keys = {
        {
            '<leader>lR',
            function()
                vim.cmd.LspRestart()
            end,
            desc = 'Reload',
        },
        {
            '<leader>lI',
            function()
                vim.cmd.LspInfo()
            end,
            desc = 'Info',
        },
    },
}
