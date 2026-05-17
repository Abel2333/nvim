# Language Support

This setup is primarily tuned for Python and Rust, with C/C++ available when
needed. Other filetypes are supported as well.

## Python

- LSP: `pyright` and `ruff` are enabled in `after/ftplugin/python.lua`.
- Linting: ruff via `nvim-lint` (`lua/abel/config/lang.lua`).
- Formatting: ruff (fix/format/imports) when available; otherwise isort + black
  (`lua/abel/plugins/editor/conform.lua`).
- Debugging: `nvim-dap-python` in `lua/abel/plugins/dap/dap-python.lua`.

## Rust

- LSP: `rust-analyzer` (`lsp/rust_analyzer.lua`) with workspace reload command.
- Additional tooling: `rustaceanvim` (`lua/abel/plugins/lsp/rustaceanvim.lua`).
- Formatting: `rustfmt` via conform.
- Debugging: codelldb adapter via DAP config (`lua/abel/config/dap.lua`).

## C/C++

- LSP: `clangd` (`after/ftplugin/cpp.lua`, `lsp/clangd.lua`).
- Formatting: `clang-format` via conform.
- Debugging: gdb, codelldb, or cppdbg (`lua/abel/config/dap.lua`).
- CMake: lint + format (`cmakelint`, `cmake-format`).

## Other Filetypes

- Lua: `lua_ls` (`after/ftplugin/lua.lua`, `lsp/lua_ls.lua`).
- JSON: `jsonls` (`after/ftplugin/json.lua`, `lsp/jsonls.lua`).
- Markdown: `marksman` (`lsp/marksman.lua`).
- Typst: `tinymist` + preview (`after/ftplugin/typst.lua`,
  `lua/abel/plugins/filetype/typst-preview.lua`).
- QML: `qmlls` (`after/ftplugin/qml.lua`).

## Tooling Install

Use `:Mason` to install or update LSP servers, formatters, and linters.
