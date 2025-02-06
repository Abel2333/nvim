-- Wrapper to avoid local defined variables file non-existent.
local M = {}

local _, defined = pcall(require, 'abel.config.defined-locals')

if defined and type(defined) == 'table' then
    M = defined
end

---Switch between different API.
---@param platform string
---@return string | nil
M.switch_api = function(platform)
    if platform == 'deepseek' then
        return M.deepseek_api_key
    elseif platform == 'siliconflow' then
        return M.siliconflow_api_key
    end
    return nil
end

return M
