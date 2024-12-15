---Integrate kitty Scrollback function to neovim
---@type LazyPluginSpec
return {
    'mikesmithgh/kitty-scrollback.nvim',
    enabled = true,
    lazy = true,
    cmd = {
        'KittyScrollbackGenerateKittens',
        'KittyScrollbackCheckHealth',
    },
    event = {
        'User KittyScrollbackLaunch',
    },
    opts = {
        {
            paste_window = {
                winopts_overrides = function(winopts)
                    winopts.border = {
                        '╭',
                        '─',
                        '╮',
                        '│',
                        '┤',
                        '─',
                        '├',
                        '│',
                    }
                    return winopts
                end,
                footer_winopts_overrides = function(winopts)
                    winopts.border = {
                        '│',
                        ' ',
                        '│',
                        '│',
                        '╯',
                        '─',
                        '╰',
                        '│',
                    }
                    return winopts
                end,
            },
            callbacks = {
                after_paste_window_ready = function(pastewin_data)
                    local winid = pastewin_data.paste_window.winid
                    vim.wo[winid].statuscolumn = ''
                    require('virt-column').setup { char = '' }
                end,
            },
        },
    },
}
