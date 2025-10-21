-- [[ Some misc settings ]]
-- Envrionment variable
-- NOTE: vim.fn.joinpath requires neovim version >= 0.10.0
--
local locals = require 'abel.config.locals'

---@diagnostic disable-next-line: param-type-mismatch
vim.env.LAZYROOT = vim.fs.joinpath(vim.fn.stdpath 'data', 'lazy')
vim.env.LAZYROCK = vim.fs.joinpath(vim.fn.stdpath 'data', 'lazy-rocks')

vim.cmd.aunmenu [[PopUp.How-to\ disable\ mouse]]
vim.cmd.aunmenu [[PopUp.-1-]]

if locals.switch_api 'deepseek' ~= nil then
    vim.env.ENABLE_AI = true
end
