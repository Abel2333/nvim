---Enhance the add/sub performance
---@type LazyPluginSpec
return {
    'monaqa/dial.nvim',
    keys = {

        {
            '<C-a>',
            function()
                require('dial.map').manipulate('increment', 'normal')
            end,
            mode = 'n',
        },
        {
            '<C-x>',
            function()
                require('dial.map').manipulate('decrement', 'normal')
            end,
            mode = 'n',
        },
        {
            'g<C-a>',
            function()
                require('dial.map').manipulate('increment', 'gnormal')
            end,
            mode = 'n',
        },
        {
            'g<C-x>',
            function()
                require('dial.map').manipulate('decrement', 'gnormal')
            end,
            mode = 'n',
        },
        {
            '<C-a>',
            function()
                require('dial.map').manipulate('increment', 'visual')
            end,
            mode = 'v',
        },
        {
            '<C-x>',
            function()
                require('dial.map').manipulate('decrement', 'visual')
            end,
            mode = 'v',
        },
        {
            'g<C-a>',
            function()
                require('dial.map').manipulate('increment', 'gvisual')
            end,
            mode = 'v',
        },
        {
            'g<C-x>',
            function()
                require('dial.map').manipulate('decrement', 'gvisual')
            end,
            mode = 'v',
        },
    },
    config = function()
        local augend = require 'dial.augend'
        require('dial.config').augends:register_group {
            default = {
                augend.constant.new {
                    elements = { 'and', 'or' },
                    word = true,
                    cyclic = true,
                },
                augend.constant.new {
                    elements = { '&&', '||' },
                    word = false,
                    cyclic = true,
                },
                augend.constant.new {
                    elements = { '==', '!=' },
                    word = false,
                    cyclic = true,
                },

                augend.integer.alias.decimal_int,
                augend.integer.alias.hex,
                augend.semver.alias.semver,
                augend.constant.alias.bool,
                augend.date.alias['%Y/%m/%d'],
                augend.date.alias['%Y-%m-%d'],
                augend.date.alias['%d/%m/%Y'],
                augend.date.alias['%d-%m-%Y'],
            },
        }
    end,
}
