---@type vim.lsp.Config
return {
    cmd = { 'ruff', 'server' },
    root_makers = {
        'pyproject.toml',
        'ruff.toml',
        'ruff.toml',
        '.git',
    },
    filetypes = { 'python' },
}
