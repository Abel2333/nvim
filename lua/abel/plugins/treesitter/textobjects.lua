-- Syntax aware text-objects, select, move, swap, and peek support.
--
---@type LazyPluginSpec
return {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    event = 'VeryLazy',
    dependencies = {
        { 'nvim-treesitter/nvim-treesitter' },
    },
    opts = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ['aa'] = { query = '@parameter.outer', desc = 'a argument' },
                ['ia'] = { query = '@parameter.inner', desc = 'inner part of a argument' },
                ['af'] = { query = '@function.outer', desc = 'a function region' },
                ['if'] = { query = '@function.inner', desc = 'inner part of a function region' },
                ['ar'] = { query = '@return.outer', desc = 'a return' },
                ['ir'] = { query = '@return.outer', desc = 'inner return' },
                ['ac'] = { query = '@class.outer', desc = 'a of a class' },
                ['ic'] = { query = '@class.inner', desc = 'inner part of a class region' },
                ['aj'] = { query = '@conditional.outer', desc = 'a judge' },
                ['ij'] = { query = '@conditional.inner', desc = 'inner part of a judge region' },
                ['al'] = { query = '@loop.outer', desc = 'a loop' },
                ['il'] = { query = '@loop.inner', desc = 'inner part of a loop' },
            },
            include_surrounding_whitespace = true,
        },
        move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
                [']a'] = { query = '@parameter.outer', desc = 'Next argument start' },
                [']f'] = { query = '@function.outer', desc = 'Next function start' },
                [']r'] = { query = '@function.outer', desc = 'Next return start' },
                [']c'] = { query = '@class.outer', desc = 'Next class start' },
                [']j'] = { query = '@conditional.outer', desc = 'Next judge start' },
                [']l'] = { query = '@loop.outer', desc = 'Next loop start' },
            },
            goto_next_end = {
                [']A'] = { query = '@parameter.outer', desc = 'Next argument end' },
                [']F'] = { query = '@function.outer', desc = 'Next function end' },
                [']R'] = { query = '@function.outer', desc = 'Next return end' },
                [']C'] = { query = '@class.outer', desc = 'Next class end' },
                [']J'] = { query = '@conditional.outer', desc = 'Next judge end' },
                [']L'] = { query = '@loop.outer', desc = 'Next loop end' },
            },
            goto_previous_start = {
                ['[a'] = { query = '@parameter.outer', desc = 'Previous argument start' },
                ['[f'] = { query = '@function.outer', desc = 'Previous function start' },
                ['[r'] = { query = '@function.outer', desc = 'Previous return start' },
                ['[c'] = { query = '@class.outer', desc = 'Previous class start' },
                ['[j'] = { query = '@conditional.outer', desc = 'Previous judge start' },
                ['[l'] = { query = '@loop.outer', desc = 'Previous loop start' },
            },
            goto_previous_end = {
                ['[A'] = { query = '@parameter.outer', desc = 'Previous argument end' },
                ['[F'] = { query = '@function.outer', desc = 'Previous function end' },
                ['[R'] = { query = '@function.outer', desc = 'Previous return end' },
                ['[C'] = { query = '@class.outer', desc = 'Previous class end' },
                ['[J'] = { query = '@conditional.outer', desc = 'Previous judge end' },
                ['[L'] = { query = '@loop.outer', desc = 'Previous loop end' },
            },
        },
    },
    config = function(_, opts)
        require('nvim-treesitter-textobjects').setup {
            select = {
                lookahead = opts.select.lookahead,
                include_surrounding_whitespace = opts.select.include_surrounding_whitespace,
            },
            move = {
                set_jumps = opts.move.set_jumps,
            },
        }

        local repeatable_move = require 'nvim-treesitter-textobjects.repeatable_move'
        local select = require 'nvim-treesitter-textobjects.select'
        local move = require 'nvim-treesitter-textobjects.move'

        for lhs, spec in pairs(opts.select.keymaps) do
            vim.keymap.set({ 'x', 'o' }, lhs, function()
                select.select_textobject(spec.query, spec.query_group)
            end, { desc = spec.desc })
        end

        local move_modes = { 'n', 'x', 'o' }
        local move_groups = {
            'goto_next_start',
            'goto_next_end',
            'goto_previous_start',
            'goto_previous_end',
        }

        for _, group in ipairs(move_groups) do
            for lhs, spec in pairs(opts.move[group]) do
                vim.keymap.set(move_modes, lhs, function()
                    move[group](spec.query, spec.query_group)
                end, { desc = spec.desc })
            end
        end

        vim.keymap.set({ 'n', 'x', 'o' }, ';', repeatable_move.repeat_last_move_next)
        vim.keymap.set({ 'n', 'x', 'o' }, ',', repeatable_move.repeat_last_move_previous)
    end,
}
