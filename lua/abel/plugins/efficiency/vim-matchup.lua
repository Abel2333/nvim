---The better matchup

---@type LazyPluginSpec
return {
    'andymass/vim-matchup',
    config = function()
        -- When matchup a bracket, highlight it
        vim.g.matchup_matchparen_enabled = 1

        -- Config the match information when cursor does not in the screen
        vim.g.matchup_matchparen_offscreen = { method = 'popup' }
        -- Set the timeout to reduce the delay in big files
        vim.g.matchup_delim_timeout = 100
    end,
}
