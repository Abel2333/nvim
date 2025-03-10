-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ','
local custom = require 'abel.config.custom'

-- [[Setting misc items]]
require 'abel.config.misc'

-- [[Setting keymaps]]
require 'abel.config.keymaps'

-- [[Setting autocmd]]
require 'abel.config.autocmds'

-- [[Setting LSP]]
require 'abel.config.lsp'

-- [[ Install and configure plugins ]]
require 'abel.config.lazy-plugins'

-- [[ Apply GUI settings ]]
if vim.g.neovide then
    require 'abel.config.gui'
end

-- Set colorscheme
vim.cmd.colorscheme(custom.theme)

-- [[Setting options]]
require 'abel.config.options'
