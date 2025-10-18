-- [[ Import Plugins ]]
-- See lazy.nvim document to get more information
--     https://github.com/folke/lazy.nvim
return {
    -- INFO: This format will automatically import
    -- the plugins in specific folder.

    { import = 'abel.plugins.lib' },

    { import = 'abel.plugins.colorscheme' },

    { import = 'abel.plugins.ui' },

    { import = 'abel.plugins.tool' },

    { import = 'abel.plugins.git' },

    { import = 'abel.plugins.efficiency' },

    { import = 'abel.plugins.treesitter' },

    { import = 'abel.plugins.mini' },

    {import = 'abel.plugins.snacks'},

    { import = 'abel.plugins.editor' },

    { import = 'abel.plugins.lsp' },

    { import = 'abel.plugins.filetype' },

    { import = 'abel.plugins.dap' },
}
