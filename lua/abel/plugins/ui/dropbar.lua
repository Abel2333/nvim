local custom = require 'abel.config.custom'

---@type LazyPluginSpec
return {
    'Bekaboo/dropbar.nvim',
    enabled = false,
    event = {
        'BufRead',
        'BufNewFile',
    },
    opts = {
        icons = {
            kinds = {
                symbols = vim.tbl_extend('keep', { Folder = ' ' }, custom.icons.kind_with_space),
            },
        },
        sources = {
            path = {
                modified = function(sym)
                    return sym:merge {
                        name = sym.name .. ' [+]',
                        name_hl = 'DiffAdded',
                    }
                end,
            },
        },
    },
}
