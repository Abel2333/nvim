---Generate the image to show code block
local misc_util = require 'abel.util.misc'

---@type LazyPluginSpec
return {
    'mistricky/codesnap.nvim',
    enabled = not misc_util.is_win(),
    build = 'make',
    event = 'VeryLazy',
    keys = {
        { '<leader>cc', '<Cmd>CodeSnap<CR>', mode = 'x', desc = 'Copy selected code snapshot into clipboard' },
        { '<leader>cs', '<Cmd>CodeSnapSave<CR>', mode = 'x', desc = 'Save selected code snapshot' },
    },
    opts = {
        save_path = '~/Pictures/CodeSnap',
        has_breadcrumbs = true,
        has_line_number = true,
        bg_theme = 'summer',
    },
}
