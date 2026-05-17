--------------------------------------------------------------------------------
-- Message history store
--------------------------------------------------------------------------------
local M = {}

---@class MessageHistoryOpt
---@field max_items? integer

---@class MessageHistoryEntry
---@field event_id integer?
---@field key? string
---@field mode? string
---@field tag string
---@field level integer
---@field source string
---@field source_id integer|string|nil
---@field timestamp integer
---@field created_at integer
---@field channel string
---@field text string
---@field content any
---@field meta table|nil

local State = {
    max_items = 300,
    items = {},
}

---@param value any
---@return any
local function safe_copy(value)
    if type(value) ~= 'table' then
        return value
    end

    local ok, copied = pcall(vim.deepcopy, value)
    if ok then
        return copied
    end
    return value
end

---@param msg Message
---@return boolean
local function should_record(msg)
    if type(msg) ~= 'table' then
        return false
    end

    local channel = msg.meta and msg.meta.channel
    if channel ~= nil and channel ~= 'message' then
        return false
    end

    if msg.tag == 'notify' then
        return true
    end

    return type(msg.tag) == 'string' and vim.startswith(msg.tag, 'msg.show.')
end

---@param msg Message
---@return MessageHistoryEntry|nil
local function build_entry(msg)
    if not should_record(msg) then
        return nil
    end

    local text = msg.text
    if type(text) ~= 'string' or text == '' then
        if type(msg.content) == 'string' and msg.content ~= '' then
            text = msg.content
        else
            text = vim.inspect(msg.content)
        end
    end

    return {
        event_id = msg.event_id,
        key = msg.key,
        mode = msg.mode,
        tag = msg.tag,
        level = msg.level,
        source = msg.source or 'user',
        source_id = msg.source_id,
        timestamp = msg.timestamp or vim.uv.now(),
        created_at = os.time(),
        channel = (msg.meta and msg.meta.channel) or 'message',
        text = text,
        content = safe_copy(msg.content),
        meta = safe_copy(msg.meta),
    }
end

---@param opts MessageHistoryOpt|nil
function M.setup(opts)
    opts = opts or {}
    if type(opts.max_items) == 'number' and opts.max_items > 0 then
        State.max_items = math.floor(opts.max_items)
    end
end

---@param msg Message
---@return boolean
function M.record(msg)
    local entry = build_entry(msg)
    if not entry then
        return false
    end

    State.items[#State.items + 1] = entry
    while #State.items > State.max_items do
        table.remove(State.items, 1)
    end
    return true
end

---@param limit? integer
---@return MessageHistoryEntry[]
function M.list(limit)
    local items = State.items
    local start_index = 1

    if type(limit) == 'number' and limit > 0 and limit < #items then
        start_index = #items - limit + 1
    end

    local ret = {}
    for i = start_index, #items do
        ret[#ret + 1] = safe_copy(items[i])
    end
    return ret
end

function M.clear()
    State.items = {}
end

---@return integer
function M.count()
    return #State.items
end

---@param id string
---@param interested BusSubscriberInterestedTagDecl
---@param min_level integer|nil
---@return BusSubscriberDecl
function M.subscriber(id, interested, min_level)
    return {
        id = id,
        interested = interested,
        min_level = min_level or vim.log.levels.TRACE,
        handler = function(msg)
            M.record(msg)
            return false
        end,
    }
end

return M
