# Toast Module

Module: `abel.util.ui.toast`

A lightweight toast-style notification window built on snacks.nvim. The window
is always opened as a floating window (`position = "float"`).

## Usage

```lua
local toast = require 'abel.util.ui.toast'

toast.notify_like("Build finished", {
  id = "build",
  title = "LSP",
  icon = " ",
  timeout = 2500,
  row = -1,
  col = -1,
  anchor = "SE",
  size = {
    width = { min = 30, max = 0.75 },
    height = { min = 1, max = 0.6 },
  },
  border = "rounded",
})
```

## API

### `notify_like(msg, opts, render) -> win`

- **msg** `string`
  - Notification text.

- **opts** `table|nil`
  - `timeout: number|false` — Auto-close delay in ms. `false/0` disables auto-close.
  - `title: string` — Title shown in the floating window title.
  - `icon: string` — Icon text. Default is derived from `level` (error/info).
  - `level: "error"|"info"|"warn"|"warning"|"debug"|"trace"` — Used only for default icon selection.
  - `ft: string` — Buffer filetype. Defaults to `"markdown"`.
  - `id: string` — Reuse an existing toast with the same id. The buffer is updated and the timer is reset. Layout is not recomputed unless `relayout = true`.
  - `added: number` — Timestamp (seconds). Defaults to `os.time()`.
  - `opts: fun(notif: table)` — Hook to mutate the notification table before render.
  - `more_format: string` — Footer format when content is truncated (e.g. `"+%d"`).
  - `border: "none"|"top"|"right"|"bottom"|"left"|"top_bottom"|"hpad"|"vpad"|"rounded"|"single"|"double"|"solid"|"shadow"|"bold"|string[]|false|true` — Border style. Defaults to `true`.
  - `size: { width?: number|{min?: number, max?: number}, height?: number|{min?: number, max?: number} }`
    - For numbers: `>= 1` is absolute; `(0, 1]` is a percentage of editor columns/lines.
    - For `{min,max}`: values follow the same rule.
  - `relayout: boolean` — When reusing an id, recompute layout if `true`.
  - `row: number|string`, `col: number|string` — Floating window position, relative to the editor. Negative values pin to bottom/right. Fractions `(0, 1)` are relative positions.
  - `anchor: "NW"|"NE"|"SW"|"SE"` — Anchor point used with `row/col`.

- **render** `function|nil`
  - `render(buf, notif, ctx)`
    - `buf`: buffer id
    - `notif`: `{ msg, title?, icon?, ft?, id?, added?, opts? }`
    - `ctx`: `{ ns, opts, hl }`
  - If nil, the built-in compact renderer is used.

## Notes

- The module enables conceal in the toast window to hide markdown markers like `**bold**`.
- The window uses snacks.nvim (`Snacks.win`) for layout and display.
