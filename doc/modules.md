# Modules

This document summarizes the main modules and where to find them.

## Bootstrap and Core

- `init.lua` and `lua/abel/init.lua` are the entry points.
- Core settings live in `lua/abel/config/`:
  - `options.lua`, `keymaps.lua`, `autocmds.lua`, `misc.lua`, `custom.lua`
  - `lsp.lua`, `dap.lua`, `capabilities.lua`

## Plugin System

- Plugin manager: `lua/abel/config/lazy-plugins.lua` (lazy.nvim bootstrap).
- Plugin groups: `lua/abel/plugins/` (organized by category).

## UI and UX

- Statusline, bufferline, notifications, and UI polish: `lua/abel/plugins/ui/`
- Snacks collection and related helpers: `lua/abel/plugins/snacks/`
- Dashboard and visuals: `lua/abel/plugins/ui/alpha.lua`, `lua/abel/config/custom.lua`

## Editor Features

- Completion, snippets, autopairs, comment, surround, todo, markdown render:
  `lua/abel/plugins/editor/`
- Custom snippets: `extend-snippets/`

## LSP and Tooling

- LSP core + Mason: `lua/abel/plugins/lsp/` and `lua/abel/plugins/tool/mason.lua`
- Per-server LSP configs: `lsp/`
- Filetype LSP enablement: `after/ftplugin/`
- Linting and formatting: `lua/abel/plugins/lsp/lint.lua`,
  `lua/abel/plugins/editor/conform.lua`

## Git

- `lua/abel/plugins/git/`: gitsigns, diffview, neogit, git-conflict, flog

## Navigation and Search

- Fuzzy finding: `lua/abel/plugins/snacks/picker.lua`
- File tree: `lua/abel/plugins/tool/neo-tree.lua`
- Telescope and helpers: `lua/abel/plugins/tool/telescope.lua`

## Tasks and Build

- Overseer task runner: `lua/abel/plugins/tool/overseer.lua`
- Task templates: `lua/abel/config/overseer/`

## Debugging

- DAP core and UI: `lua/abel/plugins/dap/`
- Adapters and configs: `lua/abel/config/dap.lua`

## Filetype Extras

- `lua/abel/plugins/filetype/`: typst, vimtex, neorg, markdown preview, etc.
- `after/ftplugin/`: per-language tweaks

## AI Tools (Optional)

- llm.nvim and Sidekick integrations: `lua/abel/plugins/efficiency/llm.lua`,
  `lua/abel/plugins/tool/sidekick.lua`
- Copilot and Codeium are present but disabled by default.

## Utilities

- Clipboard helpers for WSL/SSH: `scripts/wsl-paste.sh` and `lua/abel/config/options.lua`
- Misc utilities: `lua/abel/util/`
