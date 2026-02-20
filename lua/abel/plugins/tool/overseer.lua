---A task runner and job management plugin for Neovim

local custom = require 'abel.config.custom'
local load = require 'abel.util.base.concat_fold'

---@type LazyPluginSpec
return {
    'stevearc/overseer.nvim',
    opts = function()
        return {
            strategy = {
                'toggleterm',
                quit_on_exit = 'success',
                -- close_on_exit = 'success',
                open_on_start = false,
            },
            dap = false,
            from = {
                border = custom.border,
            },
            confirm = {
                border = custom.border,
            },
            task_win = {
                border = custom.border,
            },
            task_list = {
                bindings = {
                    ['?'] = 'ShowHelp',
                    ['g?'] = 'ShowHelp',
                    ['<CR>'] = 'RunAction',
                    ['e'] = 'Edit',
                    ['o'] = false,
                    ['v'] = 'OpenVsplit',
                    ['s'] = 'OpenSplit',
                    ['f'] = 'OpenFloat',
                    ['<C-q>'] = 'OpenQuickFix',
                    ['p'] = 'TogglePreview',
                    ['+'] = 'IncreaseDetail',
                    ['_'] = 'DecreaseDetail',
                    ['='] = 'IncreaseAllDetail',
                    ['-'] = 'DecreaseAllDetail',
                    ['['] = 'DecreaseWidth',
                    [']'] = 'IncreaseWidth',
                    -- ['k'] = 'PrevTask',
                    -- ['j'] = 'NextTask',
                    ['t'] = '<CMD>OverseerQuickAction open tab<CR>',
                    ['<C-u>'] = false,
                    ['<C-d>'] = false,
                    ['<C-h>'] = false,
                    ['<C-j>'] = false,
                    ['<C-k>'] = false,
                    ['<C-l>'] = false,
                    ['q'] = 'Close',
                },
            },
            component_aliases = {
                default = {
                    { 'display_duration', detail_level = 2 },
                    'on_output_summarize',
                    'on_exit_set_status',
                    'on_complete_notify',
                    { 'on_complete_dispose', require_view = { 'SUCCESS', 'CANCELED' } },
                    'unique',
                },
            },
            templates = {
                'builtin',
            },
        }
    end,

    config = function(_, opts)
        local overseer = require 'overseer'

        overseer.setup(opts)

        -- Load all templates
        local templates = load.load_module 'abel.config.overseer'

        -- Register them all
        -- Thus, I can put multiple templates in single file
        for _, template in ipairs(templates) do
            overseer.register_template(template)
        end

        do -- For lazy loading lualine component
            local success, lualine = pcall(require, 'lualine')
            if not success then
                return
            end
            local lualine_cfg = lualine.get_config()
            for i, item in ipairs(lualine_cfg.sections.lualine_x) do
                if type(item) == 'table' and item.name == 'overseer-placeholder' then
                    lualine_cfg.sections.lualine_x[i] = 'overseer'
                end
            end
            lualine.setup(lualine_cfg)
        end
    end,
    keys = {
        { '<leader>rr', '<Cmd>OverseerRun<CR>', desc = 'Overseer Run' },
        { '<leader>rl', '<Cmd>OverseerToggle<CR>', desc = 'Overseer List' },
        { '<leader>rb', '<Cmd>OverseerBuild<CR>', desc = 'Overseer Build' },
        { '<leader>ra', '<Cmd>OverseerTaskAction<CR>', desc = 'Overseer Action' },
        { '<leader>ri', '<Cmd>OverseerInfo<CR>', desc = 'Overseer Info' },
        { '<leader>rc', '<Cmd>OverseerClearCache<CR>', desc = 'Overseer Clear Cache' },
    },
}
