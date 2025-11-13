---@type LazyPluginSpec
return {
    'zbirenbaum/copilot.lua',
    enabled = false,
    -- dependencies = { 'copilotlsp-nvim/copilot-lsp' },
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {},
}
