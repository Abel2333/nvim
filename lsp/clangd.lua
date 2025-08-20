---@type vim.lsp.Config
return {
    cmd = {
        'clangd',
        '--all-scopes-completion',
        '--background-index',
        '--clang-tidy',
        '--clang-tidy-checks="performance-*, bugprone-*, misc-*, google-*, modernize-*, readability-*, portability-*"',
        -- '--compile-commands-dir=${workspaceFolder}/build/',
        '--completion-parse=auto',
        '--completion-style=detailed',
        '--enable-config',
        '--function-arg-placeholders=true',
        '--function-arg-placeholders=true',
        '--header-insertion-decorators',
        '--header-insertion=iwyu',
        '--include-cleaner-stdlib',
        '--log=verbose',
        '--pretty',
        '--ranking-model=decision_forest',
        '-j=12',
    },
    capabilities = {
        offsetEncoding = 'utf-16',
    },
}
