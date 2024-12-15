---Show the key you pressed on the screen

local custom = require 'abel.config.custom'

---@type LazyPluginSpec
return {
    'NStefan002/screenkey.nvim',
    cmd = 'Screenkey',
    opts = {
        win_opts = {
            border = custom.border,
        },
    },
}
