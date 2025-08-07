local M = {}

local lang = require 'abel.config.lang'
local capabilities = require 'abel.config.capabilities'
local configs = require 'lspconfig.configs'
local config_util = require 'lspconfig.util'

if not configs.ty then
    configs.ty = {
        default_config = {
            cmd = { 'ty', 'server' },
            filetypes = { 'python' },
            root_dir = function(fname)
                return config_util.root_pattern('pyproject.toml', 'ty.toml')(fname) or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
            end,
            single_file_support = true,
            settings = {},
        },
        docs = {
            description = [[
        Try this configuration of `Ty` by Abel.
        ]],
        },
    }
end

M.setup_server = function(server_name, server_opt)
    server_opt.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_opt.capabilities or {})
    require('lspconfig')[server_name].setup(server_opt)
end

M.config_servers = function()
    for server_name, server_opt in pairs(lang.servers) do
        if server_opt.enabled then
            server_opt.enabled = nil
            M.setup_server(server_name, server_opt)
        end
    end
end

return M
