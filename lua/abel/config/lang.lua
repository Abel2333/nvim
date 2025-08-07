-- The tables of LSP servers and Linters
local M = {}

local local_definition = require 'abel.config.locals'

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
        enabled = true,
    },
    -- CMake
    neocmake = {
        enabled = true,
    },
    -- gopls = {},
    ty = {
        cmd = { 'ty', 'server' },
        filetypes = { 'python' },
        root_makers = {
            'ty.toml',
            'pyproject.toml',
            '.git',
        },
        enabled = false,
    },
    pyright = {
        settings = {
            python = {
                analysis = {
                    typeCheckingMode = 'off',
                },
            },
        },
        root_makers = {
            'pyproject.toml',
            'setup.py',
            'setup.cfg',
            'requirements.txt',
            'Pipfile',
            'pyrightconfig.json',
            '.git',
        },
        filetypes = { 'python' },
        enabled = true,
    },
    basedpyright = {
        settings = {
            basedpyright = {
                analysis = { typeCheckingMode = 'off' },
            },
        },
        root_makers = {
            'pyproject.toml',
            'setup.py',
            'setup.cfg',
            'requirements.txt',
            'Pipfile',
            'pyrightconfig.json',
            '.git',
        },
        filetypes = { 'python' },
        cmd = { 'basedpyright-langserver', '--stdio' },
        enabled = false,
    },
    pylsp = {
        cmd = { 'pylsp' },
        filetypes = { 'python' },
        root_makers = {
            'pyproject.toml',
            'setup.py',
            'setup.cfg',
            'requirements.txt',
            'Pipfile',
            'pyrightconfig.json',
            '.git',
        },
        plugins = {
            pycodestyle = {
                enabled = false,
            },
            pyflakes = {
                enabled = false,
            },
        },
        enabled = false,
    },
    ruff = {
        cmd = { 'ruff', 'server' },
        root_makers = {
            'pyproject.toml',
            'ruff.toml',
            'ruff.toml',
            '.git',
        },
        filetypes = { 'python' },
        enabled = true,
    },
    -- CSharp
    omnisharp = {
        cmd = { 'dotnet', local_definition.omnisharp_dll_path },
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
    jsonls = {
        settings = {
            json = {
                format = {
                    enabled = true,
                },
                validate = { enabled = true },
            },
        },
        enabled = true,
    },
    rust_analyzer = {},
    marksman = {},
    vale_ls = {},
    tinymist = {
        single_file_support = true,
        settings = {
            formatterMode = 'typstyle',
            exportPdf = 'onSave',
        },
        enabled = true,
    },

    texlab = {
        keys = {
            { '<Leader>K', '<plug>(vimtex-doc-package)', desc = 'Vimtex Docs', silent = true },
        },
        enabled = true,
    },

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
        enabled = true,
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
