---Generate the image to show code block
local misc_util = require 'abel.util.misc'

---@type LazyPluginSpec
return {
    'mistricky/codesnap.nvim',
    enabled = not misc_util.is_win(),
    build = 'make build_generator',
    -- event = 'VeryLazy',
    keys = {
        { '<leader>cc', '<cmd>CodeSnap<cr>', mode = { 'x', 'v' }, desc = 'Save selected code snapshot into clipboard' },
        { '<leader>cs', '<cmd>CodeSnapSave<cr>', mode = { 'x', 'v' }, desc = 'Save selected code snapshot in ~/Pictures/CodeSnap/' },
    },
    opts = {
        save_path = '~/Pictures/CodeSnap',
        has_breadcrumbs = false,
        -- has_line_number = true,
        bg_theme = 'summer',
        show_workspace = true,
        watermark = vim.env.USER,
    },
}
