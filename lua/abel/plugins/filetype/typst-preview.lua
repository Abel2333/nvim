local misc_util = require 'abel.util.core.misc'
local async_task = require 'abel.util.base.task'

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
        -- This function will be called to determine the root of the typst project
        get_root = function(path_of_main_file)
            local root = os.getenv 'TYPST_ROOT'

            if root then
                return root
            end

            root = vim.fs.dirname(vim.fs.find({ 'lib.typ', '.git' }, { path = path_of_main_file, upward = true })[1])

            if root then
                return root
            end

            return vim.fn.fnamemodify(path_of_main_file, ':p:h')
        end,
    },
    config = function(_, opts)
        require('typst-preview').setup(opts)

        if not misc_util.has_software 'websocat' then
            local compile_command = 'cargo install --features=ssl websocat'
            misc_util.info('Install websocat', { title = 'typst-preview' })

            -- Install websocat
            async_task(compile_command, 'typst-preview')
        end
    end,
}
