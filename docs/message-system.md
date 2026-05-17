# Message System

This document explains the current message pipeline used by the config.

## Overview

The message system has two separate jobs:

1. render live UI messages as toast windows
2. keep a bounded in-memory history for later browsing

The important rule is that these two jobs are separate. Rendering does not store history, and history does not depend on Snacks.

## Credits

- `bus` and the message adapter are adapted from
  [`aurora0x27/nvim-config`](https://codeberg.org/aurora0x27/nvim-config.git).
- `toast` is an original implementation.

## Data Flow

```text
vim.notify / nvim.ui msg_show
        |
        v
      bus.lua
   /            \
  v              v
live renderer   history store
  |                |
  v                v
 toast window    Snacks picker
```

## Modules

### `lua/abel/util/tool/bus.lua`
The message bus. It normalizes incoming events, queues early messages, and dispatches them to subscribers.

### `lua/abel/util/ui/message/init.lua`
Bootstraps the message subsystem.

It installs:
- `message.nvim` for `vim.ui_attach` / `msg_show`
- `message.notify` for `vim.notify`
- `message.history` for storing message history
- `message.render` as the default live renderer

### `lua/abel/util/ui/message/render.lua`
The live renderer.

It turns message-channel bus events into toast windows. It does not persist anything.

### `lua/abel/util/ui/message/history.lua`
The history store.

It records only `message`-channel traffic and ignores process/progress traffic. Each entry keeps a `created_at` timestamp for display.

### `lua/abel/util/ui/message/snacks.lua`
The viewer.

It reads the history store and builds a `Snacks.picker` view. This is only presentation logic: list, preview, detail view, and copy actions.

## What is recorded

Recorded:
- `notify`
- `msg.show.*`

Not recorded:
- progress / process UI traffic
- anything outside the `message` channel

## Viewing history

Use the message history picker:

- `<leader>fh`

Inside the picker:
- `Tab`: toggle preview
- `o`: open full detail in a split
- `y`: copy message text
- `Y` / `<C-y>`: copy full detail

## Why this split exists

- The bus stays generic.
- The live renderer stays simple.
- History can evolve independently.
- Snacks is optional UI glue, not part of storage.

## Related files

- `lua/abel/util/tool/bus.lua`
- `lua/abel/util/ui/message/init.lua`
- `lua/abel/util/ui/message/render.lua`
- `lua/abel/util/ui/message/history.lua`
- `lua/abel/util/ui/message/snacks.lua`
- `lua/abel/util/lsp/lsp-progress.lua`

## Note on progress messages

`lua/abel/util/lsp/lsp-progress.lua` still uses the toast UI for live progress display, but those messages are not written into the message history.
