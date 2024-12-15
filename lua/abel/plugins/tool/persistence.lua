---@type LazyPluginSpec
return {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = { options = vim.opt.sessionoptions:get() },
    keys = {
        {
            '<leader>Ss',
            function()
                require('persistence').load()
            end,
            desc = '[S]ession: [R]estore Session',
        },
        {
            '<leader>Sl',
            function()
                require('persistence').load { last = true }
            end,
            desc = '[S]ession: Restore [L]ast Session',
        },
        {
            '<leader>Sd',
            function()
                require('persistence').stop()
            end,
            desc = "[S]ession: [D]on't Save Current Session",
        },
    },
}
