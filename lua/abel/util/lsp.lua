local M = {}

local lang = require 'abel.config.lang'
local capabilities = require 'abel.config.capabilities'

M.setup_server = function(server_name, server_opt)
    server_opt.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_opt.capabilities or {})
    require('lspconfig')[server_name].setup(server_opt)
    print(server_name)
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
