---@type LazyPluginSpec
return {
    'aserowy/tmux.nvim',
    cond = vim.env.TMUX ~= nil,
    opts = {
        navigation = {
            -- cycles to opposite pane while navigating into the border
            cycle_navigation = true,

            -- enables default keybindings (C-hjkl) for normal mode
            enable_default_keybindings = false,

            -- prevents unzoom tmux when navigating beyond vim border
            persist_zoom = false,
        },
    },
    event = 'VeryLazy',
}
