-- The tables of LSP servers and Linters
local M = {}
local workspaceFolder = function()
    return vim.fn.getcwd()
end

local local_definition = require('abel.config.locals')

M.servers = {
    --  Add any additional override configuration in the following tables. Available keys are:
    --  - cmd (table): Override the default command used to start the server
    --  - filetypes (table): Override the default list of associated filetypes for the server
    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    --  - settings (table): Override the default settings passed when initializing the server.
    clangd = {
        -- settings = {
        --     hint = { enable = true },
        -- },
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
    },
    -- CMake
    neocmake = {},
    -- gopls = {},
    pyright = {
        root_dir = workspaceFolder,
    },
    -- CSharp
    omnisharp = {
        cmd={"dotnet", local_definition.omnisharp_dll_path },
        handlers = {
            ['textDocument/definition'] = function(...)
                return require('omnisharp_extended').handler(...)
            end,
        },
        keys = {
            {
                'gd',
                function()
                    require('omnisharp_extended').lsp_definitions()
                end,
                desc = 'Goto Definition',
            },
        },
        enable_roslyn_analyzers = true,
        organize_imports_on_format = true,
        enable_import_completion = true,
    },
    -- ruff = {},
    -- rust_analyzer = {},
    -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
    --
    -- Some languages (like typescript) have entire language plugins that can be useful:
    --    https://github.com/pmizio/typescript-tools.nvim
    --
    -- But for many setups, the LSP (`tsserver`) will work just fine
    -- tsserver = {},
    --
    marksman = {},
    -- vale_ls = {},

    lua_ls = {
        -- cmd = {...},
        -- filetypes = { ...},
        -- capabilities = {},
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                },
                completion = {
                    callSnippet = 'Replace',
                },
                -- Toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                -- diagnostics = { disable = { 'missing-fields' } },
                hint = {
                    enable = true,
                    setType = true,
                },
            },
        },
    },
}

M.linters_by_ft = {
    -- Linters by filetypes
    markdown = { 'markdownlint' },
    -- Use clangd in LSP server will use clang-tidy
    -- cpp = { 'clangtidy' },
    cmake = { 'cmakelint' },
    -- python = { 'ruff' },
}

M.get_linters = function()
    local linters = {}
    for _, linter in pairs(M.linters_by_ft) do
        table.insert(linters, linter[1])
    end
    return linters
end

return M
