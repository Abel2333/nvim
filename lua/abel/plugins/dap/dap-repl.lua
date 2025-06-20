---@type LazyPluginSpec
return {
    'LiadOz/nvim-dap-repl-highlights',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
        require('nvim-dap-repl-highlights').setup()
    end,
}
