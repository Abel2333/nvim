--------------------------------------------------------------------------------
-- Snacks picker view for message history
--------------------------------------------------------------------------------
local history = require 'abel.util.ui.message.history'
local M = {}

local LEVEL_LABEL = {
    [vim.log.levels.ERROR] = 'ERROR',
    [vim.log.levels.WARN] = 'WARN',
    [vim.log.levels.INFO] = 'INFO',
    [vim.log.levels.DEBUG] = 'DEBUG',
    [vim.log.levels.TRACE] = 'TRACE',
}

local LEVEL_HL = {
    [vim.log.levels.ERROR] = 'DiagnosticError',
    [vim.log.levels.WARN] = 'DiagnosticWarn',
    [vim.log.levels.INFO] = 'DiagnosticInfo',
    [vim.log.levels.DEBUG] = 'DiagnosticHint',
    [vim.log.levels.TRACE] = 'Comment',
}

---@param level integer
---@return string
local function level_label(level)
    return LEVEL_LABEL[level] or 'INFO'
end

---@param level integer
---@return string
local function level_hl(level)
    return LEVEL_HL[level] or 'DiagnosticInfo'
end

---@param text any
---@return string
local function to_text(text)
    if type(text) == 'string' then
        return text
    end
    if text == nil then
        return ''
    end
    return vim.inspect(text)
end

---@param text string
---@return string
local function one_line(text)
    return vim.trim((text or ''):gsub('\n', ' '))
end

---@param created_at integer
---@return string
local function format_time(created_at)
    return os.date('%Y-%m-%d %H:%M:%S', created_at or os.time())
end

---@param entry MessageHistoryEntry
---@return string
local function preview_text(entry)
    local lines = {
        '# Message',
        '',
        ('- Time: %s'):format(format_time(entry.created_at)),
        ('- Level: %s'):format(level_label(entry.level)),
        ('- Source: %s'):format(entry.source or ''),
        ('- Tag: %s'):format(entry.tag or ''),
        ('- Mode: %s'):format(entry.mode or ''),
    }

    if entry.key then
        lines[#lines + 1] = ('- Key: %s'):format(entry.key)
    end

    if entry.source_id ~= nil then
        lines[#lines + 1] = ('- Source ID: %s'):format(tostring(entry.source_id))
    end

    lines[#lines + 1] = ''
    lines[#lines + 1] = '## Text'
    lines[#lines + 1] = '```'
    lines[#lines + 1] = to_text(entry.text)
    lines[#lines + 1] = '```'

    if entry.content ~= nil and entry.content ~= entry.text then
        lines[#lines + 1] = ''
        lines[#lines + 1] = '## Content'
        lines[#lines + 1] = '```lua'
        lines[#lines + 1] = to_text(entry.content)
        lines[#lines + 1] = '```'
    end

    if entry.meta ~= nil then
        lines[#lines + 1] = ''
        lines[#lines + 1] = '## Meta'
        lines[#lines + 1] = '```lua'
        lines[#lines + 1] = to_text(entry.meta)
        lines[#lines + 1] = '```'
    end

    return table.concat(lines, '\n')
end

---@param item table
---@return snacks.picker.Highlight[]
local function format_item(item)
    return item.display or {}
end

---@param item table|nil
---@return MessageHistoryEntry|nil
local function get_entry(item)
    if not item then
        return nil
    end
    return item.item or item
end

---@param picker snacks.Picker
---@param item table|nil
local function copy_text(picker, item)
    local entry = get_entry(item)
    if not entry then
        return
    end
    vim.fn.setreg('+', entry.text or '')
    vim.notify('Copied message text', vim.log.levels.INFO, { title = 'Message History' })
end

---@param picker snacks.Picker
---@param item table|nil
local function copy_full(picker, item)
    local entry = get_entry(item)
    if not entry then
        return
    end
    vim.fn.setreg('+', preview_text(entry))
    vim.notify('Copied full message', vim.log.levels.INFO, { title = 'Message History' })
end

---@param picker snacks.Picker
---@param item table|nil
local function open_detail(picker, item)
    local entry = get_entry(item)
    if not entry then
        return
    end

    picker:norm(function()
        picker:close()
        local buf = vim.api.nvim_create_buf(false, true)
        vim.bo[buf].buftype = 'nofile'
        vim.bo[buf].bufhidden = 'wipe'
        vim.bo[buf].swapfile = false
        vim.bo[buf].filetype = 'markdown'
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(preview_text(entry), '\n', { plain = true }))
        vim.cmd 'botright split'
        vim.api.nvim_win_set_buf(0, buf)
    end)
end

---@param entry MessageHistoryEntry
---@param rank integer
---@return snacks.picker.finder.Item
local function build_item(entry, rank)
    local text = one_line(entry.text)
    local search = table.concat({
        format_time(entry.created_at),
        level_label(entry.level),
        entry.source or '',
        entry.tag or '',
        entry.key or '',
        text,
    }, ' ')

    return {
        idx = rank,
        score = rank,
        text = search,
        item = entry,
        preview = {
            text = preview_text(entry),
            ft = 'markdown',
        },
        display = {
            { format_time(entry.created_at), 'SnacksPickerTime' },
            { ' ' },
            { ('%-5s'):format(level_label(entry.level)), level_hl(entry.level) },
            { ' ' },
            { entry.source or '', 'SnacksPickerSpecial' },
            { ' ' },
            { entry.tag or '', 'SnacksPickerComment' },
            { '  ' },
            { text, 'SnacksPickerNormal' },
        },
    }
end

---@param opts? table
function M.open(opts)
    opts = opts or {}
    local limit = opts.limit
    opts.limit = nil

    local snacks = rawget(_G, 'Snacks')
    if type(snacks) ~= 'table' or type(snacks.picker) ~= 'table' then
        vim.notify('Snacks is not available', vim.log.levels.ERROR)
        return
    end

    local entries = history.list(limit)
    if #entries == 0 then
        vim.notify('No message history', vim.log.levels.INFO, { title = 'Message History' })
        return
    end

    local items = {}
    local rank = 0
    for i = #entries, 1, -1 do
        rank = rank + 1
        items[#items + 1] = build_item(entries[i], rank)
    end

    local picker_opts = {
        source = 'Message History',
        items = items,
        layout = { preset = 'default' },
        preview = 'preview',
        format = format_item,
        confirm = function(picker)
            picker:close()
        end,
        actions = {
            copy_text = copy_text,
            copy_full = copy_full,
            open_detail = open_detail,
        },
        win = {
            input = {
                keys = {
                    ['<Tab>'] = 'toggle_preview',
                    ['o'] = { 'open_detail', mode = { 'n', 'i' }, desc = 'Open detail' },
                    ['y'] = { 'copy_text', mode = { 'n', 'i' }, desc = 'Copy text' },
                    ['Y'] = { 'copy_full', mode = { 'n', 'i' }, desc = 'Copy full' },
                    ['<C-y>'] = { 'copy_full', mode = { 'n', 'i' }, desc = 'Copy full' },
                },
            },
            preview = {
                keys = {
                    ['o'] = { 'open_detail', mode = { 'n' }, desc = 'Open detail' },
                    ['y'] = { 'copy_text', mode = { 'n' }, desc = 'Copy text' },
                    ['Y'] = { 'copy_full', mode = { 'n' }, desc = 'Copy full' },
                },
            },
        },
    }

    picker_opts = vim.tbl_deep_extend('force', picker_opts, opts)
    snacks.picker.pick(picker_opts)
end

return M
