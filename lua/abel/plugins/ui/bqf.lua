---Better quickfix window

local custom = require 'abel.config.custom'
local misc = require 'abel.util.misc'

---@type LazyPluginSpec
return {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    -- enabled=false,
    -- NOTE: Manage the version of fzf by system package manager
    -- dependencies = {
    --     'junegunn/fzf',
    --     build = function()
    --         vim.fn['fzf#install']()
    --     end,
    -- },
    init = function()
        if not misc.has_software 'fzf' then
            misc.err('Fzf not found.', { title = 'bqf.nvim' })
        end
    end,
    opts = {
        auto_resize_height = true,
        preview = {
            border = custom.border,
            winblend = 0,
        },
    },
}
