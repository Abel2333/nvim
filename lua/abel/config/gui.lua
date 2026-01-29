-- [[ Options ]]
-- Set GUI font
vim.opt.guifont = 'FiraCode Nerd Font:h16'

-- Full Screen
vim.g.neovide_fullscreen = true

-- Disable input method in neovide.
vim.g.neovide_input_ime = false

-- Helper function for transparency formatting
-- INFO: The transparent will make some strange
-- in lualine. Thus cancel transparent under linux
-- using other mehtod instead.
if require('abel.util.core.misc').is_win() then
    vim.g.neovide_transparency = 0.8
end

-- [[ Keymap ]]
-- Toggle input method editor under Insert, Command, Terminal modes
vim.keymap.set({ 'c', 'i', 't' }, '<S-Space>', function()
    vim.g.neovide_input_ime = not vim.g.neovide_input_ime
end, { desc = 'Toggle input method editor', silent = true })

-- [[ AutoCmp ]]
-- Disable Input Method Editor
vim.api.nvim_create_autocmd({ 'ModeChanged' }, {
    group = vim.api.nvim_create_augroup('ime_input', { clear = true }),
    pattern = '*',
    desc = 'Disable IME when change mode',
    callback = function()
        vim.g.neovide_input_ime = false
    end,
})
