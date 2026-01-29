local figure = require 'abel.util.core.figure'
local render = require 'abel.util.core.render'

return {

    { 'nvimdev/dashboard-nvim', enabled = false },
    { 'echasnovski/mini.starter', enabled = false },
    -- Dashboard. This runs when neovim starts, and is what displays
    -- the "LAZYVIM" banner.
    ---@type LazyPluginSpec
    ---@type LazyPluginSpec
    {
        'goolord/alpha-nvim',
        event = 'VimEnter',
        enabled = true,
        init = false,
        dependencies = {
            'folke/snacks.nvim'
        },
        opts = function()
            local dashboard = require 'alpha.themes.dashboard'
            local header, colorized = render.ascii_render(figure.Neorange[1], figure.Neorange[2])

            dashboard.section.header.val = header
            dashboard.section.header.opts = {
                hl = colorized,
                position = 'center',
            }
            dashboard.section.buttons.val = {
                dashboard.button('f', ' ' .. ' [F]ind File', "<Cmd> lua Snacks.picker.files() <CR>"),
                dashboard.button('r', ' ' .. ' [R]ecent Files', "<Cmd> lua Snacks.picker.recent() <CR>"),
                dashboard.button('l', '󰒲 ' .. ' [L]azy', '<Cmd> Lazy <CR>'),
                dashboard.button('q', ' ' .. ' [Q]uit', '<Cmd> qa <CR>'),
            }
            for _, button in ipairs(dashboard.section.buttons.val) do
                button.opts.hl = 'AlphaButtons'
                button.opts.hl_shortcut = 'AlphaShortcut'
            end
            -- dashboard.section.header.opts.hl = 'AlphaHeader'
            dashboard.section.buttons.opts.hl = 'AlphaButtons'
            dashboard.section.footer.opts.hl = 'AlphaFooter'
            -- dashboard.opts.layout[1].val = 8
            return dashboard
        end,

        config = function(_, dashboard)
            -- close Lazy and re-open when the dashboard is ready
            if vim.o.filetype == 'lazy' then
                vim.cmd.close()
                vim.api.nvim_create_autocmd('User', {
                    once = true,
                    pattern = 'AlphaReady',
                    callback = function()
                        require('lazy').show()
                    end,
                })
            end

            require('alpha').setup(dashboard.opts)

            vim.api.nvim_create_autocmd('User', {
                once = true,
                pattern = 'LazyVimStarted',
                callback = function()
                    local stats = require('lazy').stats()
                    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                    dashboard.section.footer.val = '󱐋 Neovim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms 󱐋'
                    pcall(vim.cmd.AlphaRedraw)
                end,
            })
        end,
    },
}
