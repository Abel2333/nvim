-- [[ LSP settings ]]

local custom = require 'abel.config.custom'

-- Set diagnostic options
vim.diagnostic.config {
    virtual_text = {
        spacing = 4,
        prefix = '',
    },
    float = {
        severity_sort = true,
        source = 'if_many',
    },
    severity_sort = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = custom.icons.diagnostic.error,
            [vim.diagnostic.severity.WARN] = custom.icons.diagnostic.warn,
            [vim.diagnostic.severity.INFO] = custom.icons.diagnostic.info,
            [vim.diagnostic.severity.HINT] = custom.icons.diagnostic.hint,
        },
    },
}

-- Set signs for DAP
vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DiagnosticError' })
vim.fn.sign_define('DapBreakCondition', { text = '', texthl = 'DiagnosticError' })
vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DiagnosticInfo' })
vim.fn.sign_define('DapStopped', { text = '', texthl = 'Constant', linehl = 'debugPC' })
vim.fn.sign_define('DapBreakpointRejected', { text = '' })

-- WARN: Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
-- Be aware that you also will need to properly configure your LSP server to
-- provide the inlay hints.:
vim.lsp.inlay_hint.enable()

-- LSP provides Neovim with features like:
--  - Go to definition
--  - Find references
--  - Autocompletion
--  - Symbol Search
--  - and more!

--  This function gets run when an LSP attaches to a particular buffer.
--    That is to say, every time a new file is opened that is associated with
--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--    function will be executed to configure the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(event)
        local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-t>.
        map('gd', require('telescope.builtin').lsp_definitions, 'Goto Definition')

        -- Find references for the word under your cursor.
        map('gr', require('telescope.builtin').lsp_references, 'Goto References')

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map('gI', require('telescope.builtin').lsp_implementations, 'Goto Implementation')

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type Definition')

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map('<leader>fy', require('telescope.builtin').lsp_document_symbols, 'Document Symbols')

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace Symbols')

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        map('<leader>rn', vim.lsp.buf.rename, 'Rename')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')

        map('<leader>li', vim.lsp.buf.incoming_calls, 'Incoming calls')
        map('<leader>lo', vim.lsp.buf.outgoing_calls, 'Outgoing calls')

        -- Opens a popup that displays documentation about the word under your cursor
        --  See `:help K` for why this keymap.
        --  NOTE: merged in plugin ufo
        --
        -- map('K', vim.lsp.buf.hover, 'Hover Documentation')

        map('gD', vim.lsp.buf.declaration, 'Goto Declaration')

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })
        end

        -- The following autocommand is used to enable inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map('<leader>th', function()
                ---@diagnostic disable-next-line: param-type-mismatch
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(nil), nil)
            end, 'Toggle Inlay Hints')
        end
    end,
})

vim.api.nvim_create_autocmd('LspDetach', {
    group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
    callback = function(event)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event.buf }
    end,
})
