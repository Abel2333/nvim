local custom = require 'abel.config.custom'
local lang = require 'abel.config.lang'

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

        -- Useful status updates for LSP.
        { 'j-hui/fidget.nvim', opts = {} },

        -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
        -- used for completion, annotations and signatures of Neovim apis
        { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
        require('lspconfig.ui.windows').default_options.border = custom.border
        local capabilities = require 'abel.config.capabilities'

        local servers = lang.servers

        -- Ensure the servers and tools above are installed
        require('mason').setup()

        -- You can add other tools here that you want Mason to install
        -- for you, so that they are available from within Neovim.
        local ensure_installed = vim.tbl_keys(servers or {})

        require('mason-lspconfig').setup {
            ensure_installed = ensure_installed,
            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    -- This handles overriding only values explicitly passed
                    -- by the server configuration above. Useful when disabling
                    -- certain features of an LSP (for example, turning off formatting for tsserver)
                    server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                    require('lspconfig')[server_name].setup(server)
                end,
            },
        }
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
