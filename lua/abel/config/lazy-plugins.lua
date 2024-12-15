-- [[ Configure and install plugins ]]
--
-- Ensure to install lazy.nvim
local root = vim.env.LAZYROOT
local lazypath = vim.fs.joinpath(root, 'lazy.nvim')
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    }
end
vim.opt.runtimepath:prepend(lazypath)

local custom = require 'abel.config.custom'
-- This will add plugins accroding to the file
-- `abel.plugins.init.lua`
require('lazy').setup('abel.plugins', {
    root = root,
    install = {
        --missing = true,
        colorscheme = { 'default' },
    },
    ui = {
        -- If you are using a Nerd Font: set icons to an empty table which will use the
        -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
        ui = custom.icons.ui,
        border = custom.border,
    },
    diff = {
        cmd = 'diffview.nvim',
    },
})
