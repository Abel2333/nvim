---The tool to manage LSP servers, linters, and formaters

---@type LazyPluginSpec
return {
    'williamboman/mason.nvim',
    keys = {
        { '<leader>lm', '<Cmd>Mason<CR>', desc = 'Mason' },
    },
    opts = {
        ui = {
            border = require('abel.config.custom').border,
        },
    },
}
