---@type vim.lsp.Config
return {
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            completion = {
                callSnippet = 'Replace',
            },
            -- Toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
            hint = {
                enable = true,
                setType = true,
            },
        },
    },
}
