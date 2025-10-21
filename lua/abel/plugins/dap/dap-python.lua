---@type LazyPluginSpec
return {
    'mfussenegger/nvim-dap-python',
    ft = { 'python' },
    build = false,
    opts = {},
    config = function(_, opts)
        require('dap-python').setup('python', opts)
    end,
    keys = {
        {
            '<leader>dn',
            function()
                require('dap-python').test_method()
            end,
            desc = 'Test method',
        },
        {
            '<leader>df',
            function()
                require('dap-python').test_class()
            end,
            desc = 'Test Class',
        },
        {
            '<leader>ds',
            function()
                require('dap-python').debug_selection()
            end,
            mode = 'v',
            desc = 'Debug Selection',
        },
    },
}
