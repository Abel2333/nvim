-- The tables of LSP servers and Linters
local M = {}

M.linters_by_ft = {
    -- Linters by filetypes
    -- markdown = { 'markdownlint' },
    -- Use clangd in LSP server will use clang-tidy
    -- cpp = { 'clangtidy' },
    cmake = { 'cmakelint' },
    python = { 'ruff' },
}

M.get_linters = function()
    local linters = {}
    for _, linter in pairs(M.linters_by_ft) do
        table.insert(linters, linter[1])
    end
    return linters
end

return M
