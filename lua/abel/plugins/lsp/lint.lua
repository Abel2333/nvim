-- [[ Linter setting ]]
-- Linter is a static check tool for language
-- It can check the errors in your code

local misc_util = require 'abel.util.core.misc'

---@type LazyPluginSpec
return {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
        local lint = require 'lint'
        lint.linters_by_ft = require('abel.config.lang').linters_by_ft
        lint.linters.cmakelint.args = {
            '--filter=-whitespace/indent,-linelength',
        }

        -- Check if the needed linters are exist.
        for fs, linter in pairs(lint.linters_by_ft) do
            local actual_linter
            if linter[1] == 'clangtidy' then
                actual_linter = 'clang-tidy'
            else
                actual_linter = linter[1]
            end
            if not misc_util.has_software(actual_linter) then
                misc_util.warn('Linter: ' .. actual_linter .. ' for ' .. fs .. ' does not exist.', { title = 'nvim-lint' })
            end
        end

        -- Create autocommand which carries out the actual linting
        -- on the specified events.
        local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
        vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
            group = lint_augroup,
            callback = function()
                require('lint').try_lint()
            end,
        })
    end,
}
