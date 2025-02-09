---@type LazyPluginSpec
return {
    'Exafunction/codeium.nvim',
    enabled = false,
    cmd = 'Codeium',
    event = 'InsertEnter',
    build = ':Codeium Auth',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    config = function()
        require('codeium').setup {}
    end,
}
