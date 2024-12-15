-- [[ Basic Keymaps ]]
-- See `:help vim.keymap.set()'

local misc_util = require 'abel.util.misc'
local Color = require("abel.util.color")

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<Cmd>nohlsearch<CR>')

vim.keymap.set('', 'j', 'gj')
vim.keymap.set('', 'k', 'gk')
vim.keymap.set('', 'gj', 'j')
vim.keymap.set('', 'gk', 'k')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous Diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next Diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic Error messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic Quickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, just normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.

-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', 'jk', '<C-\\><C-n>', { desc = 'Enter terminal mode' })

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<Cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<Cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<Cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<Cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows

--  See `:help wincmd' for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Switch to normal mode fastly.
vim.keymap.set('i', 'jk', '<Esc>', { desc = 'Enter normal mode' })

-- Move lines up and down
-- NOTE: The next two lines will be a flash of cmdline
-- vim.keymap.set('v', 'J', ":move '>+1<CR>gv=gv", { desc = 'Move the selected text down' })
-- vim.keymap.set('v', 'K', ":move '<-2<CR>gv=gv", { desc = 'Move the selected text up' })
-- But these two lines would not
vim.keymap.set('v', 'J', function()
    misc_util.move_block 'down'
end, { desc = 'Move the selected text down' })
vim.keymap.set('v', 'K', function()
    misc_util.move_block 'up'
end, { desc = 'Move the selected text up' })


vim.keymap.set('n', '<leader>tc', function()
    print(misc_util.has_plugin('kitty-scrollback'))
end, { desc = 'Test Color' })
