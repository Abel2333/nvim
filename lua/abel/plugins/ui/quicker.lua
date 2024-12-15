---@type LazyPluginSpec
return {
    'stevearc/quicker.nvim',
    event = 'LspAttach',
    ---@module 'quicker'
    ---@type quicker.SetupOptions
    opts = {},
    -- keys = {
    --     {
    --         '<leader>q',
    --         function()
    --             require('quicker').toggle()
    --         end,
    --         desc = 'Toggle quickfix',
    --     },
    --     {
    --         '<leader>L',
    --         function()
    --             require('quicker').toggle { loclist = true }
    --         end,
    --         desc = 'Toggle loclist',
    --     },
    -- },
}
