---@type LazyPluginSpec
return {
    'echasnovski/mini.nvim',
    -- enabled = false,
    event = 'VeryLazy',
    config = function()
        require('mini.icons').setup {}
    end,
}
