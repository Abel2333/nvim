---A plugin used to write note well
---@type LazyPluginSpec
return {
    'nvim-neorg/neorg',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    -- lazy = false,
    ft = { 'norg' },
    version = '*',
    opts = {
        load = {
            ['core.defaults'] = {}, -- Loads default behaviour
            ['core.concealer'] = { -- Adds pretty icons to your documents
                config = {
                    icons = {
                        todo = {
                            pending = {
                                icon = '',
                            },
                        },
                    },
                },
            },
            ['core.dirman'] = { -- Manages Neorg workspaces
                config = {
                    workspaces = {
                        notes = '~/Notes',
                    },
                    default_workspace = 'notes',
                },
            },
        },
    },
    config = function(_, opts)
        require('neorg').setup(opts)

        -- hide all markup text
        vim.wo.conceallevel = 2
    end,
}
