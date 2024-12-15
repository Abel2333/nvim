-- Add the status line on the bottom
---@type LazyPluginSpec
return {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    init = function()
        vim.g.lualine_laststatus = vim.o.laststatus
        if vim.fn.argc(-1) > 0 then
            -- set an empty statusline till lualine loads
            vim.o.statusline = ' '
        else
            -- hide the statusline on the starter page
            vim.o.laststatus = 0
        end
    end,
    opts = {
        options = {
            theme = 'auto',
            -- component_separators = { left = '', right = '' },
            -- section_separators = { left = '', right = '' },
            component_separators = { left = '', right = '' },
            -- section_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            globalstatus = true,
            disabled_filetypes = {
                statusline = {
                    -- 'alpha',
                },
                winbar = {
                    'alpha',
                },
            },
        },
        -- Lualine has sections as shown below.
        -- +-------------------------------------------------+
        -- | A | B | C                             X | Y | Z |
        -- +-------------------------------------------------+
        -- Each sections holds its components
        sections = {
            lualine_a = { 'mode' },
            lualine_b = {
                'branch',
                'diff',
                'diagnostics',
            },
            lualine_c = {
                {
                    'filename',
                    file_status = true, -- Displays file status (readonly status, modified status)
                    icon_only = true,
                    separator = '',
                    padding = { left = 1, right = 0 },
                    -- Path configurations
                    -- 0: Just the filename
                    -- 1: Relative path
                    -- 2: Absolute path
                    -- 3: Absolute path, with tilde as the home directory
                    -- 4: Filename and parent dir, with tilde as the home directory
                    path = 1,
                    shorting_target = 40, -- Shortens path to leave 40 spaces in the window
                },
            },
            lualine_x = {
                require('abel.util.lualine').indent,
                { -- a placeholder of overseer, to ensure overseer will be loaded after lualine
                    name = 'overseer-placeholder',
                    function()
                        return ''
                    end,
                },
                'encoding',
                'filetype',
            },
            lualine_y = { 'progress' },
            lualine_z = { 'location' },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { 'filename' },
            lualine_x = { 'location' },
            lualine_y = {},
            lualine_z = {},
        },
        extensions = {
            'man',
            'quickfix',
            'nvim-tree',
            'neo-tree',
            'lazy',
            'toggleterm',
            'symbols-outline',
            'aerial',
            'nvim-dap-ui',
            'mundo',
        },
    },
}
