---Show images
local misc_util = require 'abel.util.misc'

---@type LazyPluginSpec
return {
    '3rd/image.nvim',
    -- This plugin could not work under the Windows
    enabled = not misc_util.is_win(),
    dependencies = {
        'leafo/magick',
    },
    ft = { 'markdown' },
    event = function(plugin)
        return {
            {
                event = 'BufRead',
                pattern = plugin.opts.hijack_file_patterns,
            },
        }
    end,
    opts = {
        hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.avif', '*.svg' },
        backend = 'kitty',
        integrations = {
            markdown = {
                enabled = true,
                clear_in_insert_mode = false,
                download_remote_images = true,
                only_render_image_at_cursor = false,
                filetypes = { 'markdown', 'vimwiki' }, -- markdown extensions (ie. quarto) can go here
            },
            neorg = {
                enabled = true,
                clear_in_insert_mode = false,
                download_remote_images = true,
                only_render_image_at_cursor = false,
                filetypes = { 'norg' },
            },
            html = {
                enabled = false,
            },
            css = {
                enabled = false,
            },
        },
        max_width = nil,
        max_height = nil,
        max_width_window_percentage = nil,
        max_height_window_percentage = 50,
        tmux_show_only_in_active_window = true,
        editor_only_render_when_focused = true,
    },
}
