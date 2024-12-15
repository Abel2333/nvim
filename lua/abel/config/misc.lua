-- [[ Some misc settings ]]
-- Envrionment variable
-- NOTE: vim.fn.joinpath requires neovim version >= 0.10.0
--
local locals = require 'abel.config.locals'

---@diagnostic disable-next-line: param-type-mismatch
vim.env.LAZYROOT = vim.fs.joinpath(vim.fn.stdpath 'data', 'lazy')

vim.cmd.aunmenu [[PopUp.How-to\ disable\ mouse]]
vim.cmd.aunmenu [[PopUp.-1-]]

-- Check whether neovim in the TMUX environment
vim.env.OPENAI_API_KEY = locals.openai_api_key
