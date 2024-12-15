---A task runner and job management plugin for Neovim

local custom = require 'abel.config.custom'

---@type LazyPluginSpec
return {
    'stevearc/overseer.nvim',
    opt = function()
        return {
            strategy = {
                'toggleterm',
                quit_on_exit = 'success',
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
            component_aliases = {
                default = {
                    { 'display_duration', detail_level = 2 },
                    'on_output_summarize',
                    'on_exit_set_status',
                    'on_complete_notify',
                    'on_complete_dispose',
                    'unique',
                },
            },
        }
    end,

    config = function(_, opts)
        local overseer = require 'overseer'

        overseer.setup(opts)

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

        local templates = {
            {
                name = 'C++ build single file',
                builder = function()
                    return {
                        cmd = { 'g++' },
                        args = {
                            '-g',
                            vim.fn.expand '%:p',
                            '-o',
                            vim.fn.expand '%:p:t:r',
                        },
                    }
                end,
                condition = {
                    filetype = { 'cpp' },
                },
            },
        }
        for _, template in ipairs(templates) do
            overseer.register_template(template)
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
