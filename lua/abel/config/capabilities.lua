-- LSP Servers and Clients are able to communicate to each other what features they support.
-- By default, Neovim does not support everything that is in the LSP specification.
-- When we add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
-- Thus, we create new capabilities with nvim cmp, and then broadcast that to the servers.

-- Default LSP server settings
local M = vim.lsp.protocol.make_client_capabilities()

-- Additional capabilities supported by nvim-cmp
M.textDocument.completion = {
  dynamicRegistration = false,
  completionItem = {
    snippetSupport = true,
    commitCharactersSupport = true,
    deprecatedSupport = true,
    preselectSupport = true,
    tagSupport = {
      valueSet = {
        1, -- Deprecated
      },
    },
    insertReplaceSupport = true,
    resolveSupport = {
      properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
        "sortText",
        "filterText",
        "insertText",
        "textEdit",
        "insertTextFormat",
        "insertTextMode",
      },
    },
    insertTextModeSupport = {
      valueSet = {
        1, -- asIs
        2, -- adjustIndentation
      },
    },
    labelDetailsSupport = true,
  },
  contextSupport = true,
  insertTextMode = 1,
  completionList = {
    itemDefaults = {
      "commitCharacters",
      "editRange",
      "insertTextFormat",
      "insertTextMode",
      "data",
    },
  },
}

-- Enabld LSP folddingRange capabilities
M.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
}

return M
