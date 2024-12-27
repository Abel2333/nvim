---Neo-tree is a Neovim plugin to browse the file system

local custom = require 'abel.config.custom'
local tree_util = require 'abel.util.neo-tree'
local kinds = vim.iter(custom.icons.kind):fold({}, function(t, k, v)
    t[k] = { icon = v }
    return t
end)

---@type LazyPluginSpec
return {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'main',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
        'MunifTanjim/nui.nvim',
        's1n7ax/nvim-window-picker',
    },
    init = function()
        vim.api.nvim_create_autocmd('BufEnter', {
            group = vim.api.nvim_create_augroup('load_neo_tree', {}),
            desc = 'Loads neo-tree when openning a directory',
            callback = function(args)
                local stats = vim.uv.fs_stat(args.file)

                if not stats or stats.type ~= 'directory' then
                    return
                end
                require 'neo-tree'
                return true
            end,
        })
    end,
    opts = {
        default_source = 'last',
        popup_border_style = custom.border,
        default_component_configs = {
            icon = {
                folder_closed = '',
                folder_open = '',
                folder_empty = '',
            },
            file_icons = {
                ['norg'] = '󱞁',
            },
        },
        separator = { left = '▏', right = '▕' },
        window = {
            width = custom.width,
            mappings = {
                ['<Space>'] = 'none',
                ['gx'] = 'system_open',
                ['h'] = 'smart_h',
                ['l'] = 'smart_l',
                -- Swap default split behavior
                ['S'] = 'open_vsplit',
                ['s'] = 'open_split',
            },
        },
        commands = {
            -- Try to open the file.
            system_open = tree_util.system_open,

            -- Try to move left in file tree smartly.
            smart_h = tree_util.smart_left,

            -- Try to move right in file tree smartly.
            smart_l = tree_util.smart_right,
        },
        filesystem = {
            group_empty_dirs = true,
            follow_current_file = {
                enabled = true,
            },
            window = {
                mappings = {
                    ['[g'] = 'none',
                    [']g'] = 'none',
                    ['[h'] = 'prev_git_modified',
                    [']h'] = 'next_git_modified',
                    ['\\'] = 'close_window',
                },
            },
            document_symbols = {
                kinds = kinds,
            },
        },
    },
    config = function(_, opts)
        require('neo-tree').setup(opts)
        vim.api.nvim_create_augroup('load_neo_tree', {})
    end,
    keys = {
        { '\\', '<Cmd>Neotree reveal<CR>', { desc = 'NeoTree reveal' } },
    },
}
