local M = {}

---@param str string A string wait for detect
---@param start_pos integer Refers a specific char
local get_len = function(str, start_pos)
    local byte = string.byte(str, start_pos)
    if not byte then
        return nil
    end
    return (byte < 0x80 and 1) or (byte < 0xE0 and 2) or (byte < 0xF0 and 3) or (byte < 0xF8 and 4) or 1
end

local colorize = function(figure, figure_color_map, colors)
    for letter, color in pairs(colors) do
        local color_name = 'Render' .. letter
        vim.api.nvim_set_hl(0, color_name, color)
        colors[letter] = color_name
    end

    local colorized = {}

    for i, line in ipairs(figure_color_map) do
        local colorized_line = {}
        local pos = 0

        for j = 1, #line do
            local start = pos
            pos = pos + get_len(figure[i], start + 1)

            local color_name = colors[line:sub(j, j)]
            if color_name then
                table.insert(colorized_line, { color_name, start, pos })
            end
        end
        table.insert(colorized, colorized_line)
    end

    return colorized
end

function M.ascii_render(color_map, colors)
    local figure = {}
    for _, line in ipairs(color_map) do
        local figure_line = [[]]
        for i = 1, #line do
            if line:sub(i, i) ~= ' ' then
                figure_line = figure_line .. '█'
            else
                figure_line = figure_line .. ' '
            end
        end
        table.insert(figure, figure_line)
    end

    return figure, colorize(figure, color_map, colors)
end

return M
