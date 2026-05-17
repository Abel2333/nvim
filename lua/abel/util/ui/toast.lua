local uv = vim.uv or vim.loop

--------------------------------------------------------------------------------
-- Toast window implementation
-- Original implementation by Abel.
--------------------------------------------------------------------------------
local NS = vim.api.nvim_create_namespace 'abel_toast_ns'

local ACTIVE = {}
local ORDER = {
    message = {},
    progress = {},
}
local NEXT_ID = 0
local RESIZE_GROUP = vim.api.nvim_create_augroup('AbelToastLayout', { clear = true })
local RESIZE_HOOKED = false

---@alias AbelNotifyLevel "error"|"info"|"warn"|"warning"|"debug"|"trace"
---@alias AbelNotifyAnchor "NW"|"NE"|"SW"|"SE"
---@alias AbelNotifyChannel "message"|"progress"|string

---@class AbelNotifyFlex
---@field min? number -- >=1 absolute value; (0,1] treated as percentage
---@field max? number -- >=1 absolute value; (0,1] treated as percentage

---@class AbelNotifySize
---@field width? number|AbelNotifyFlex -- number: >=1 absolute columns; (0,1] treated as percentage
---@field height? number|AbelNotifyFlex -- number: >=1 absolute rows; (0,1] treated as percentage

---@class AbelNotifyOpts
---@field timeout? number|false
---@field title? string
---@field icon? string
---@field level? AbelNotifyLevel
---@field ft? string
---@field id? string
---@field added? number
---@field opts? fun(notif: AbelNotify)
---@field more_format? string
---@field border? "none"|"top"|"right"|"bottom"|"left"|"top_bottom"|"hpad"|"vpad"|"rounded"|"single"|"double"|"solid"|"shadow"|"bold"|string[]|false|true
---@field relayout? boolean
---@field size? AbelNotifySize
---@field row? number|string
---@field col? number|string
---@field anchor? AbelNotifyAnchor
---@field channel? AbelNotifyChannel

---@class AbelNotifyHL
---@field title string
---@field icon string
---@field msg string
---@field border string
---@field footer string

---@class AbelNotifyCtx
---@field ns integer
---@field opts table
---@field hl AbelNotifyHL

---@class AbelNotify
---@field msg string
---@field title? string
---@field icon? string
---@field ft? string
---@field id? string
---@field added? number
---@field opts? fun(notif: AbelNotify)

---@alias AbelNotifyRender fun(buf: integer, notif: AbelNotify, ctx: AbelNotifyCtx)

---@class AbelNotifyState
---@field id string
---@field channel AbelNotifyChannel
---@field buf integer
---@field win integer?
---@field timer? uv.uv_timer_t
---@field width integer
---@field height integer
---@field total_width integer
---@field total_height integer
---@field explicit boolean
---@field pos { row:number|string|nil, col:number|string|nil, anchor:AbelNotifyAnchor|nil }
---@field win_config table
---@field wrap boolean
---@field hl AbelNotifyHL

local CHANNELS = {
    message = {
        anchor = 'NE',
        margin_row = 1,
        margin_col = 1,
        gap = 1,
        stack = 'down',
        insert = 'front',
        max_visible = 6,
    },
    progress = {
        anchor = 'SE',
        margin_row = 1,
        margin_col = 1,
        gap = 1,
        stack = 'up',
        insert = 'back',
        max_visible = 3,
    },
}

local function default_hl()
    return {
        title = 'Title',
        icon = 'Identifier',
        msg = 'NormalFloat',
        border = 'FloatBorder',
        footer = 'Comment',
    }
end

---@param msg string
---@param opts AbelNotifyOpts
---@return AbelNotify
local function build_notif(msg, opts)
    local icon = opts.icon
    if icon == nil and opts.level ~= nil then
        if opts.level == 'error' then
            icon = ' '
        elseif opts.level == 'warn' or opts.level == 'warning' then
            icon = ' '
        elseif opts.level == 'debug' then
            icon = ' '
        elseif opts.level == 'trace' then
            icon = ' '
        else
            icon = ' '
        end
    end

    return {
        msg = tostring(msg or ''),
        title = opts.title,
        icon = icon or '',
        ft = opts.ft,
        id = opts.id,
        added = opts.added or os.time(),
        opts = opts.opts,
    }
end

---@param value number
---@param min number
---@param max number
---@param parent number
---@return number
local function dim(value, min, max, parent)
    min = math.floor(min < 1 and (parent * min) or min)
    max = math.floor(max < 1 and (parent * max) or max)
    return math.min(max, math.max(min, value))
end

---@param value number|AbelNotifyFlex|nil
---@param current number
---@param parent number
---@return number
local function resolve_size_value(value, current, parent)
    if type(value) == 'number' then
        if value >= 1 then
            return math.floor(value)
        end
        if value > 0 then
            return math.floor(parent * value)
        end
        return current
    end
    if type(value) == 'table' then
        local min = value.min or 0
        local max = value.max or 1
        return dim(current, min, max, parent)
    end
    return current
end

---@return integer, integer
local function screen_size()
    local uis = vim.api.nvim_list_uis()
    if uis[1] then
        return uis[1].width, uis[1].height
    end
    return vim.o.columns, vim.o.lines
end

---@param border AbelNotifyOpts.border|nil
---@return string|string[]
local function normalize_border(border)
    if border == nil or border == true then
        return 'rounded'
    end
    if border == false or border == 'none' then
        return 'none'
    end
    return border
end

---@param border string|string[]
---@return boolean
local function has_border(border)
    return border ~= 'none'
end

---@param border string|string[]
---@return integer, integer
local function border_padding(border)
    if has_border(border) then
        return 2, 2
    end
    return 0, 0
end

---@param value any
---@return integer
local function display_width(value)
    if value == nil then
        return 0
    end
    if type(value) == 'string' then
        return vim.fn.strdisplaywidth(value)
    end
    if type(value) == 'table' then
        local parts = {}
        for _, item in ipairs(value) do
            if type(item) == 'string' then
                parts[#parts + 1] = item
            elseif type(item) == 'table' and type(item[1]) == 'string' then
                parts[#parts + 1] = item[1]
            end
        end
        return vim.fn.strdisplaywidth(table.concat(parts))
    end
    return vim.fn.strdisplaywidth(tostring(value))
end

---@param list string[]
---@param id string
local function list_remove(list, id)
    for i = #list, 1, -1 do
        if list[i] == id then
            table.remove(list, i)
            return
        end
    end
end

---@return string
local function next_id()
    NEXT_ID = NEXT_ID + 1
    return 'toast:' .. NEXT_ID
end

---@param channel AbelNotifyChannel|nil
---@return AbelNotifyChannel
local function normalize_channel(channel)
    if type(channel) == 'string' and channel ~= '' then
        return channel
    end
    return 'message'
end

---@param buf integer
---@param ft string|nil
local function configure_buffer(buf, ft)
    vim.bo[buf].buftype = 'nofile'
    vim.bo[buf].bufhidden = 'wipe'
    vim.bo[buf].swapfile = false
    vim.bo[buf].modifiable = false
    vim.bo[buf].filetype = ft or 'markdown'
end

---@param win integer
---@param hl AbelNotifyHL
---@param wrap boolean
local function configure_window(win, hl, wrap)
    local winhighlight = ('Normal:%s,NormalNC:%s,FloatBorder:%s,FloatTitle:%s,FloatFooter:%s'):format(
        hl.msg,
        hl.msg,
        hl.border,
        hl.title,
        hl.footer
    )
    vim.api.nvim_set_option_value('winhighlight', winhighlight, { win = win })
    vim.api.nvim_set_option_value('wrap', wrap, { win = win })
    vim.api.nvim_set_option_value('linebreak', wrap, { win = win })
    vim.api.nvim_set_option_value('number', false, { win = win })
    vim.api.nvim_set_option_value('relativenumber', false, { win = win })
    vim.api.nvim_set_option_value('signcolumn', 'no', { win = win })
    vim.api.nvim_set_option_value('foldcolumn', '0', { win = win })
    vim.api.nvim_set_option_value('statuscolumn', '', { win = win })
    vim.api.nvim_set_option_value('conceallevel', 2, { win = win })
    vim.api.nvim_set_option_value('concealcursor', 'n', { win = win })
    vim.api.nvim_set_option_value('spell', false, { win = win })
    vim.api.nvim_set_option_value('list', false, { win = win })
end

---@param buf integer
---@param notif AbelNotify
---@param ctx AbelNotifyCtx
local function render_compact(buf, notif, ctx)
    local title = vim.trim((notif.icon or '') .. ' ' .. (notif.title or ''))
    if title ~= '' then
        ctx.opts.title = { { ' ' .. title .. ' ', ctx.hl.title } }
        ctx.opts.title_pos = 'center'
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(notif.msg or '', '\n', { plain = true }))
end

---@param buf integer
---@param notif AbelNotify
---@param ctx AbelNotifyCtx
---@param render AbelNotifyRender|nil
local function render_to_buf(buf, notif, ctx, render)
    if type(notif.opts) == 'function' then
        notif.opts(notif)
    end

    ctx = ctx or {}
    ctx.ns = ctx.ns or NS
    ctx.opts = ctx.opts or {}
    ctx.hl = ctx.hl or default_hl()
    render = render or render_compact

    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_clear_namespace(buf, ctx.ns, 0, -1)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
    render(buf, notif, ctx)
    vim.bo[buf].modifiable = false
end

---@param lines string[]
---@param width integer
---@param wrap boolean
---@return integer
local function measure_height(lines, width, wrap)
    if not wrap then
        return math.max(1, #lines)
    end
    local total = 0
    local safe_width = math.max(width, 1)
    for _, line in ipairs(lines) do
        local line_width = vim.fn.strdisplaywidth(line)
        total = total + math.max(1, math.ceil(line_width / safe_width))
    end
    return math.max(1, total)
end

---@param buf integer
---@param view table
---@param opts AbelNotifyOpts
---@return integer, integer
local function compute_dims(buf, view, opts)
    local screen_w, screen_h = screen_size()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    if #lines == 0 then
        lines = { '' }
    end

    local width = 1
    for _, line in ipairs(lines) do
        width = math.max(width, vim.fn.strdisplaywidth(line))
    end
    width = math.max(width, display_width(view.title), display_width(view.footer))
    width = dim(width, 20, 0.4, screen_w)
    width = resolve_size_value(opts.size and opts.size.width, width, screen_w)
    width = math.max(1, width)

    local wanted_height = measure_height(lines, width, view.wrap ~= false)
    local height = dim(wanted_height, 1, 0.6, screen_h)
    height = resolve_size_value(opts.size and opts.size.height, height, screen_h)
    height = math.max(1, height)

    if wanted_height > height and has_border(view.border) and opts.more_format then
        view.footer = opts.more_format:format(wanted_height - height)
        view.footer_pos = 'right'
        width = math.max(width, display_width(view.footer))
        width = resolve_size_value(opts.size and opts.size.width, width, screen_w)
        width = math.max(1, width)
    end

    return width, height
end

---@param timeout number|false
---@return boolean
local function should_autoclose(timeout)
    return timeout ~= nil and timeout ~= false and timeout ~= 0
end

---@param state AbelNotifyState
---@param skip_relayout boolean|nil
local function close_state(state, skip_relayout)
    if state.timer then
        pcall(state.timer.stop, state.timer)
        pcall(state.timer.close, state.timer)
        state.timer = nil
    end
    if state.win and vim.api.nvim_win_is_valid(state.win) then
        pcall(vim.api.nvim_win_close, state.win, true)
        state.win = nil
    end
    if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
        pcall(vim.api.nvim_buf_delete, state.buf, { force = true })
        state.buf = -1
    end
    ACTIVE[state.id] = nil
    local order = ORDER[state.channel]
    if order then
        list_remove(order, state.id)
    end
    if not skip_relayout and order then
        -- relayout is handled by dismiss() or show()
    end
end

---@param channel AbelNotifyChannel
---@return table
local function channel_conf(channel)
    return CHANNELS[channel] or CHANNELS.message
end

---@param state AbelNotifyState
local function insert_state(state)
    local conf = channel_conf(state.channel)
    local order = ORDER[state.channel]
    if not order then
        order = {}
        ORDER[state.channel] = order
    end

    if conf.insert == 'front' then
        table.insert(order, 1, state.id)
    else
        order[#order + 1] = state.id
    end

    while #order > conf.max_visible do
        local victim_id = conf.insert == 'front' and order[#order] or order[1]
        local victim = ACTIVE[victim_id]
        if victim then
            close_state(victim, true)
        else
            list_remove(order, victim_id)
        end
    end
end

---@param value number|string|nil
---@param fallback number
---@param max_index integer
---@return number
local function resolve_axis(value, fallback, max_index)
    if type(value) == 'string' then
        value = tonumber(value)
    end
    if type(value) ~= 'number' then
        return fallback
    end
    if value > 0 and value < 1 then
        return math.floor(max_index * value)
    end
    if value < 0 then
        return math.max(0, max_index + math.floor(value))
    end
    return math.max(0, math.floor(value))
end

---@param state AbelNotifyState
---@param anchor AbelNotifyAnchor
---@param row integer
---@param col integer
local function place_state(state, anchor, row, col)
    local screen_w, screen_h = screen_size()
    row = math.max(0, math.min(row, screen_h - 1))
    col = math.max(0, math.min(col, screen_w - 1))

    local cfg = vim.tbl_extend('force', state.win_config, {
        relative = 'editor',
        anchor = anchor,
        row = row,
        col = col,
    })

    if not state.win or not vim.api.nvim_win_is_valid(state.win) then
        state.win = vim.api.nvim_open_win(state.buf, false, cfg)
    else
        vim.api.nvim_win_set_config(state.win, cfg)
    end

    configure_window(state.win, state.hl, state.wrap)
end

---@param state AbelNotifyState
local function place_explicit(state)
    local screen_w, screen_h = screen_size()
    local conf = channel_conf(state.channel)
    local anchor = state.pos.anchor or conf.anchor
    local default_row = (anchor == 'SW' or anchor == 'SE') and (screen_h - 2) or 1
    local default_col = (anchor == 'NE' or anchor == 'SE') and (screen_w - 2) or 1
    local row = resolve_axis(state.pos.row, default_row, screen_h - 1)
    local col = resolve_axis(state.pos.col, default_col, screen_w - 1)
    place_state(state, anchor, row, col)
end

---@param channel AbelNotifyChannel
local function relayout_channel(channel)
    local order = ORDER[channel]
    if not order then
        return
    end

    local screen_w, screen_h = screen_size()
    local conf = channel_conf(channel)
    local base_col = screen_w - 2 - conf.margin_col

    local cursor
    if conf.stack == 'down' then
        cursor = 1 + conf.margin_row
    else
        cursor = screen_h - 2 - conf.margin_row
    end

    for _, id in ipairs(vim.deepcopy(order)) do
        local state = ACTIVE[id]
        if not state then
            list_remove(order, id)
        elseif state.explicit then
            place_explicit(state)
        else
            if conf.stack == 'down' then
                local next_bottom = cursor + state.total_height - 1
                if next_bottom > screen_h - 1 then
                    close_state(state, true)
                else
                    place_state(state, conf.anchor, cursor, base_col)
                    cursor = next_bottom + 1 + conf.gap
                end
            else
                local next_top = cursor - state.total_height + 1
                if next_top < 0 then
                    close_state(state, true)
                else
                    place_state(state, conf.anchor, cursor, base_col)
                    cursor = next_top - 1 - conf.gap
                end
            end
        end
    end
end

local function relayout_all()
    for channel, _ in pairs(ORDER) do
        relayout_channel(channel)
    end
end

local function ensure_resize_hook()
    if RESIZE_HOOKED then
        return
    end
    vim.api.nvim_create_autocmd('VimResized', {
        group = RESIZE_GROUP,
        callback = function()
            relayout_all()
        end,
    })
    RESIZE_HOOKED = true
end

---@param state AbelNotifyState
---@param timeout number|false
local function reset_timer(state, timeout)
    if state.timer then
        pcall(state.timer.stop, state.timer)
        pcall(state.timer.close, state.timer)
        state.timer = nil
    end

    if not should_autoclose(timeout) then
        return
    end

    local timer = assert(uv.new_timer())
    state.timer = timer
    timer:start(timeout, 0, function()
        pcall(timer.stop, timer)
        pcall(timer.close, timer)
        state.timer = nil
        vim.schedule(function()
            local current = ACTIVE[state.id]
            if current then
                local channel = current.channel
                close_state(current, true)
                relayout_channel(channel)
            end
        end)
    end)
end

---@param msg string
---@param opts AbelNotifyOpts|nil
---@param render AbelNotifyRender|nil
---@return AbelNotifyState
local function show(msg, opts, render)
    opts = opts or {}

    local id = opts.id or next_id()
    local channel = normalize_channel(opts.channel)
    local state = ACTIVE[id]
    local is_new = false

    if not state then
        local buf = vim.api.nvim_create_buf(false, true)
        configure_buffer(buf, opts.ft)
        state = {
            id = id,
            channel = channel,
            buf = buf,
            win = nil,
            timer = nil,
            width = 1,
            height = 1,
            total_width = 1,
            total_height = 1,
            explicit = false,
            pos = { row = nil, col = nil, anchor = nil },
            win_config = {},
            wrap = true,
            hl = default_hl(),
        }
        ACTIVE[id] = state
        is_new = true
    else
        configure_buffer(state.buf, opts.ft)
    end

    if state.channel ~= channel then
        local old_order = ORDER[state.channel]
        if old_order then
            list_remove(old_order, state.id)
        end
        state.channel = channel
        is_new = true
    end

    state.explicit = opts.row ~= nil or opts.col ~= nil or opts.anchor ~= nil
    state.pos = {
        row = opts.row,
        col = opts.col,
        anchor = opts.anchor,
    }

    local notif = build_notif(msg, vim.tbl_extend('force', opts, { id = id }))
    local view = {
        border = normalize_border(opts.border),
        title = nil,
        title_pos = 'center',
        footer = nil,
        footer_pos = 'right',
        wrap = true,
    }

    render_to_buf(state.buf, notif, {
        ns = NS,
        opts = view,
        hl = state.hl,
    }, render)

    local width, height = compute_dims(state.buf, view, opts)
    local border_w, border_h = border_padding(view.border)

    state.width = width
    state.height = height
    state.total_width = width + border_w
    state.total_height = height + border_h
    state.wrap = view.wrap ~= false
    state.win_config = {
        width = width,
        height = height,
        style = 'minimal',
        border = view.border,
        noautocmd = true,
        focusable = false,
        zindex = 200,
    }

    if has_border(view.border) and view.title ~= nil then
        state.win_config.title = view.title
        state.win_config.title_pos = view.title_pos
    end

    if has_border(view.border) and view.footer ~= nil then
        state.win_config.footer = view.footer
        state.win_config.footer_pos = view.footer_pos
    end

    ensure_resize_hook()

    if is_new then
        insert_state(state)
    end

    if state.explicit then
        place_explicit(state)
    else
        relayout_channel(state.channel)
    end

    reset_timer(state, opts.timeout == nil and 3000 or opts.timeout)
    return state
end

---@param id string
local function dismiss(id)
    local state = ACTIVE[id]
    if not state then
        return
    end
    local channel = state.channel
    close_state(state, true)
    relayout_channel(channel)
end

---@class AbelNotifyModule
---@field show fun(msg: string, opts: AbelNotifyOpts|nil, render: AbelNotifyRender|nil): AbelNotifyState
---@field dismiss fun(id: string)

---@type AbelNotifyModule
return {
    show = show,
    dismiss = dismiss,
}
