local misc_util = require 'abel.util.misc'

---@type LazyPluginSpec
return {
    'chomosuke/typst-preview.nvim',
    ft = 'typst',
    opts = {
        invert_color = 'auto',
        dependencies_bin = {
            ['tinymist'] = misc_util.is_win() and 'tinymist.CMD' or 'tinymist',
            ['websocat'] = 'websocat',
        },
    },
    config = function(_, opts)
        require('typst-preview').setup(opts)

        if not misc_util.has_software 'websocat' then
            local compile_command = 'cargo install --features=ssl websocat'
            misc_util.info('Install websocat', { title = 'typst-preview' })

            -- Install websocat
            misc_util.async_task(compile_command, 'typst-preview')
        end
    end,
}
