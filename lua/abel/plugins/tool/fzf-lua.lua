---Fuzzy find based on fzf

local custom = require 'abel.config.custom'

---@type LazyPluginSpec
return {
    'ibhagwan/fzf-lua',
    cmd = { 'FzfLua' },
    enabled = false,
    opts = {
        hls = {
            normal = 'NormalFloat',
            border = 'FloatBorder',
            title = 'FloatTitle',
            preview_normal = 'NormalFloat',
            preview_border = 'FloatBorder',
            preview_title = 'FloatTitle',
        },
        fzf_colors = {
            ['fg'] = { 'fg', 'NormalFloat' },
            ['bg'] = { 'bg', 'NormalFloat' },
            ['hl'] = { 'fg', 'Statement' },
            ['fg+'] = { 'fg', 'NormalFloat' },
            ['bg+'] = { 'bg', 'CursorLine' },
            ['hl+'] = { 'fg', 'Statement' },
            ['info'] = { 'fg', 'PreProc' },
            ['prompt'] = { 'fg', 'Conditional' },
            ['pointer'] = { 'fg', 'Exception' },
            ['marker'] = { 'fg', 'Keyword' },
            ['spinner'] = { 'fg', 'Label' },
            ['header'] = { 'fg', 'Comment' },
            ['gutter'] = { 'bg', 'NormalFloat' },
        },
        files = {
            formatter = 'path.filename_first',
        },
        winopts = {
            border = custom.border,
        },
        lsp = {
            symbols = {
                symbol_icons = custom.icons.kind,
            },
        },
    },
    keys = {
        {
            '<leader>ff',
            function()
                require('fzf-lua').files()
            end,
            desc = 'Files',
        },
        {
            '<leader>fn',
            function()
                require('fzf-lua').files { cwd = vim.fn.stdpath 'config' }
            end,
            desc = 'Neovim files',
        },
        {
            '<leader>fb',
            function()
                require('fzf-lua').buffers()
            end,
            desc = 'Buffers',
        },
        {
            '<leader>f?',
            function()
                require('fzf-lua').help_tags()
            end,
            desc = 'Help tags',
        },
        {
            '<leader>fo',
            function()
                require('fzf-lua').oldfiles()
            end,
            desc = 'Old files',
        },
        {
            '<leader>fm',
            function()
                require('fzf-lua').marks()
            end,
            desc = 'Marks',
        },
        {
            '<leader>fk',
            function()
                require('fzf-lua').keymaps()
            end,
            desc = 'Keymaps',
        },
        {
            '<leader>fs',
            function()
                require('fzf-lua').lsp_document_symbols()
            end,
            desc = 'Symbols in current document',
        },
        {
            '<leader>fS',
            function()
                require('fzf-lua').lsp_workspace_symbols()
            end,
            desc = 'Symbols in current workspace',
        },
        {
            '<leader>fc',
            function()
                require('fzf-lua').colorschemes()
            end,
            desc = 'Colorscheme',
        },
        {
            '<leader>fH',
            function()
                require('fzf-lua').highlights()
            end,
            desc = 'Highlights',
        },
        {
            '<leader>fj',
            function()
                require('fzf-lua').jumps()
            end,
            desc = 'Jumplist',
        },
        {
            '<leader>fw',
            function()
                require('fzf-lua').live_grep_native()
            end,
            desc = 'Live grep',
        },
        -- git
        {
            '<leader>fgc',
            function()
                require('fzf-lua').git_commits()
            end,
            desc = 'Commits',
        },
        {
            '<leader>fgb',
            function()
                require('fzf-lua').git_branchs()
            end,
            desc = 'Branchs',
        },
        {
            '<leader>fgt',
            function()
                require('fzf-lua').git_tags()
            end,
            desc = 'Tags',
        },

        -- dap
        {
            '<leader>fde',
            function()
                require('fzf-lua').dap_commands()
            end,
            desc = 'Commands',
        },
        {
            '<leader>fdc',
            function()
                require('fzf-lua').dap_configurations()
            end,
            desc = 'Configurations',
        },
        {
            '<leader>fdb',
            function()
                require('fzf-lua').dap_breakpoints()
            end,
            desc = 'Breakpoints',
        },
        {
            '<leader>fdv',
            function()
                require('fzf-lua').dap_variables()
            end,
            desc = 'Variables',
        },
        {
            '<leader>fdf',
            function()
                require('fzf-lua').dap_frames()
            end,
            desc = 'Frames',
        },
    },
}
