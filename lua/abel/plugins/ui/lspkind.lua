local custom = require 'abel.config.custom'

---@type LazyPluginSpec
return {
    'onsails/lspkind.nvim',
    lazy = true,
    opts = {
        symbol_map = custom.icons.kind,
    },
}
