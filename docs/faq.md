# FAQ and Implementation Notes

This document collects common questions and the implementation details they
reference. Each FAQ links back to the relevant implementation notes below.

## FAQ Index

- [How is LaTeX/Typst formula preview implemented?](#q-how-is-latextypst-formula-preview-implemented)
- [How does clipboard work over SSH?](#q-how-does-clipboard-work-over-ssh)
- [How does clipboard work in WSL?](#q-how-does-clipboard-work-in-wsl)
- [How does clipboard work in tmux?](#q-how-does-clipboard-work-in-tmux)

## Implementation Notes

### LaTeX/Typst Math Preview

- Entry point: `lua/abel/plugins/snacks/image.lua`
- Renderer: `snacks.image` with `math.enabled = true`
- Rendering mode: floating window (`inline = false`, `float = true`)
- Templates:
  - Typst template defines page size, text size, and equation rendering.
  - LaTeX template uses `standalone` with extra math packages.
- Icons: `math = '󰍘 '`, `chart = '󰄧 '`, `image = ' '`

Notes:
- The comment in the config mentions that a Treesitter parser must be
  available for enabled languages.

### Clipboard Over SSH (OSC52)

- Entry point: `lua/abel/config/options.lua`
- Condition: `SSH_TTY` is set and not in TMUX.
- Clipboard provider: `vim.ui.clipboard.osc52`

Notes:
- Clipboard is configured for both `+` and `*` registers.

### Clipboard in WSL

- Entry points: `lua/abel/config/options.lua`, `scripts/wsl-paste.sh`
- Copy: `win32yank.exe -i`
- Paste: `scripts/wsl-paste.sh`
- Script behavior: `wl-paste | tr -d '\r'`

Notes:
- `clip.exe` is intentionally not used (commented out in the config).

### Clipboard in tmux

- Entry point: `lua/abel/plugins/tool/tmux.lua`
- Plugin: `aserowy/tmux.nvim` is loaded when `TMUX` is set.

Notes:
- This repo does not customize tmux clipboard behavior directly. Clipboard
  behavior inside tmux is handled by tmux itself and your tmux config.

## FAQ

### Q: How is LaTeX/Typst formula preview implemented?

A: It uses `snacks.image` math rendering with custom Typst/LaTeX templates.
See: “LaTeX/Typst Math Preview” above.

### Q: How does clipboard work over SSH?

A: When `SSH_TTY` is present and TMUX is not, OSC52 is used via
`vim.ui.clipboard.osc52`. See: “Clipboard Over SSH (OSC52)” above.

### Q: How does clipboard work in WSL?

A: Copy uses `win32yank.exe -i`; paste goes through `scripts/wsl-paste.sh`
which calls `wl-paste` and strips CR. See: “Clipboard in WSL” above.

### Q: How does clipboard work in tmux?

A: When running inside tmux, `tmux.nvim` is loaded (see `lua/abel/plugins/tool/tmux.lua`).
Clipboard behavior itself is provided by tmux and your tmux config; this repo
does not override it. See: “Clipboard in tmux” above.
