---@type vim.lsp.Config
return {
    cmd = { 'marksman', 'server' },
    root_markers = { '.marksman.toml', '.git' },
    filetypes = { 'markdown', 'markdown.mdx' },
    single_file_support = true,
}
