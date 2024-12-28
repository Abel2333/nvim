local custom = require 'abel.config.custom'

---@type LazyPluginSpec
return {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    init = function()
        if custom.prefer_tabpage then
            vim.o.showtabline = 1
            vim.o.tabline = ' '
        end
    end,
    keys = {
        { '<M-1>', '<Cmd>BufferLineGoToBuffer 1<CR>', desc = 'Go to Buffer 1' },
        { '<M-2>', '<Cmd>BufferLineGoToBuffer 2<CR>', desc = 'Go to Buffer 2' },
        { '<M-3>', '<Cmd>BufferLineGoToBuffer 3<CR>', desc = 'Go to Buffer 3' },
        { '<M-4>', '<Cmd>BufferLineGoToBuffer 4<CR>', desc = 'Go to Buffer 4' },
        { '<M-5>', '<Cmd>BufferLineGoToBuffer 5<CR>', desc = 'Go to Buffer 5' },
        { '<M-6>', '<Cmd>BufferLineGoToBuffer 6<CR>', desc = 'Go to Buffer 6' },
        { '<M-7>', '<Cmd>BufferLineGoToBuffer 7<CR>', desc = 'Go to Buffer 7' },
        { '<M-8>', '<Cmd>BufferLineGoToBuffer 8<CR>', desc = 'Go to Buffer 8' },
        { '<M-9>', '<Cmd>BufferLineGoToBuffer 9<CR>', desc = 'Go to Buffer 9' },

        { '<M-S-Right>', '<Cmd>+tabmove<CR>', desc = 'Move tab to next' },
        { '<M-S-Left>', '<Cmd>-tabmove<CR>', desc = 'Move tab to previous' },

        { '<leader>bt', '<Cmd>tabnew<CR>', desc = 'New tab' },
        { '<leader>bn', '<Cmd>tabnext<CR>', desc = 'Next tab' },
        { '<leader>bp', '<Cmd>tabprevious<CR>', desc = 'Previous tab' },

        { '<leader>bc', '<cmd>BufferLinePickClose<CR>', desc = 'Close' },
        {
            '<leader>bse',
            '<cmd>BufferLineSortByExtension<CR>',
            desc = 'By extension',
        },
        {
            '<leader>bsd',
            '<cmd>BufferLineSortByDirectory<CR>',
            desc = 'By directory',
        },
        { '<leader>bst', '<cmd>BufferLineSortByTabs<CR>', desc = 'By tabs' },
    },
    opts = {
        options = {
            numbers = 'ordinal',
            show_close_icon = false,
            mode = 'buffers',
            indicator = {
                icon = ' ', -- this should be omitted if indicator style is not 'icon'
                style = 'underline',
            },
            -- separator_style = "slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
            separator_style = 'thin',
            buffer_close_icon = custom.icons.misc.close,
            offsets = {
                {
                    filetype = 'neo-tree',
                    text = 'Explorer',
                    text_align = 'center',
                    saperator = true,
                },
                {
                    filetype = 'aerial',
                    text = 'Outline',
                    text_align = 'center',
                    saperator = true,
                },
                {
                    filetype = 'Outline',
                    text = 'Outline',
                    text_align = 'center',
                    saperator = true,
                },
                {
                    filetype = 'dbui',
                    text = 'Database Manager',
                    text_align = 'center',
                    saperator = true,
                },
                {
                    filetype = 'DiffviewFiles',
                    text = 'Source Control',
                    text_align = 'center',
                    separator = true,
                },
                {
                    filetype = 'httpResult',
                    text = 'Http Result',
                    text_align = 'center',
                    saperator = true,
                },
                {
                    filetype = 'OverseerList',
                    text = 'Tasks',
                    text_align = 'center',
                    saperator = true,
                },
                {
                    filetype = 'flutterToolsOutline',
                    text = 'Flutter Outline',
                    text_align = 'center',
                    saperator = true,
                },
            },
            diagnostics = 'nvim_lsp',
            diagnostics_indicator = function(count)
                return '(' .. count .. ')'
            end,
            show_duplicate_prefix = true,
        },
    },
}
