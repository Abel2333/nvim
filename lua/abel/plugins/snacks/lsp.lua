---A collection of small QoL plugins for Neovim
---@type LazyPluginSpec
return {
    'folke/snacks.nvim',
    ---@class Snacks: snacks.plugins
    opts = {
        rename = {
            enabled = true,
        },
    },
    keys = {
        -- lsp
        {
            'gd',
            function()
                Snacks.picker.lsp_definitions()
            end,
            desc = 'Goto Definition',
        },
        {
            'gD',
            function()
                Snacks.picker.lsp_declarations()
            end,
            desc = 'Goto Declaration',
        },
        {
            'gD',
            function()
                Snacks.picker.lsp_type_definitions()
            end,
            desc = 'Goto Type Definition',
        },
        {
            'gI',
            function()
                Snacks.picker.lsp_implementations()
            end,
            desc = 'Goto Implementation',
        },
        {
            '<leader>lf',
            function()
                Snacks.rename.rename_file()
            end,
            desc = 'Rename File',
        },
        {
            '<leader>li',
            function()
                Snacks.picker.lsp_incoming_calls {
                    auto_confirm = false,
                }
            end,
            desc = 'Incoming calls',
        },
        {
            '<leader>lo',
            function()
                Snacks.picker.lsp_outgoing_calls {
                    auto_confirm = false,
                }
            end,
            desc = 'Outgoing Calls',
        },
    },
}
