---@type LazyPluginSpec
return {
    'altermo/ultimate-autopair.nvim',
    event = { 'InsertEnter', 'CmdlineEnter' },
    enabled = true,
    opts = {
        tabout = {
            enable = true,
            map = '<Tab>',
            hopout = true,
            do_nothing_if_fail = false,
        },
    },
}
