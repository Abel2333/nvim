-- LSP Servers and Clients are able to communicate to each other what features they support.
-- By default, Neovim does not support everything that is in the LSP specification.
-- When we add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
-- Thus, we create new capabilities with nvim cmp, and then broadcast that to the servers.

-- Default LSP server settings
local M = vim.lsp.protocol.make_client_capabilities()

-- Load nvim-cmp
local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not ok then
    require('abel.util.misc').err('Could not load nvim-cmp', { title = 'LSP Capabilities' })
    return
end

-- Add additional capabilities support by nvim-cmp
M = vim.tbl_deep_extend('force', M, cmp_nvim_lsp.default_capabilities())

-- Enabld LSP folddingRange capabilities
M.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
}

return M
