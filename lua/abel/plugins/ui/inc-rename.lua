--- increase the performance of rename
---@type LazyPluginSpec
return {
    'smjonas/inc-rename.nvim',
    dependencies = { 'folke/snacks.nvim' },
    keys = {
        {
            '<leader>lr',
            function()
                return ':IncRename ' .. vim.fn.expand '<cword>'
            end,
            expr = true,
            desc = 'Rename Symbol',
        },
    },
    config = function()
        require('inc_rename').setup {
            input_buffer_type = 'snacks',
        }
    end,
}
