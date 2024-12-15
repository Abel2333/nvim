---A plugin to load snippets
---@type LazyPluginSpec
return {
    'L3MON4D3/LuaSnip',
    event = {
        'InsertEnter',
        'CmdlineEnter',
    },
    build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
        end
        return 'make install_jsregexp'
    end)(),
    dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        'rafamadriz/friendly-snippets',
    },
    keys = {
        {
            '<C-k>',
            function()
                require('luasnip').expand()
            end,
            mode = 'i',
        },
    },
    opts = function()
        local types = require 'luasnip.util.types'

        return {
            store_selection_keys = '<Enter>',
            update_events = { 'TextChanged', 'TextChangedI' },
            ext_opts = {
                [types.choiceNode] = {
                    active = {
                        virt_text = { { '●', 'Operatore' } },
                        virt_text_pos = 'inline',
                    },
                    unvisited = {
                        virt_text = { { '●', 'Comment' } },
                        virt_text_pos = 'inline',
                    },
                },
                [types.insertNode] = {
                    active = {
                        virt_text = { { '●', 'Keyword' } },
                        virt_text_pos = 'inline',
                    },
                    unvisited = {
                        virt_text = { { '●', 'Comment' } },
                        virt_text_pos = 'inline',
                    },
                },
            },
        }
    end,
    config = function(_, opts)
        ---@diagnostic disable param-type-mismatch
        local config_path = vim.fn.stdpath 'config'
        local plugin_path = vim.fs.joinpath(vim.fn.stdpath 'data', 'lazy')

        require('luasnip').setup(opts)
        require('luasnip').config.setup { enable_autosnippets = true }

        require('luasnip.loaders.from_vscode').lazy_load {
            paths = {
                vim.fs.joinpath(config_path, 'extend-snippets'),
                vim.fs.joinpath(plugin_path, 'friendly-snippets'),
            },
        }
    end,
}
