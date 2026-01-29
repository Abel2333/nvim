local uv = vim.uv or vim.loop
local NS = vim.api.nvim_create_namespace 'my_notifier_ns'
local ACTIVE = {}

-- Default highlight groups (customizable)
local function default_hl()
    return {
        title = 'Title',
        icon = 'Identifier',
        msg = 'NormalFloat',
        border = 'FloatBorder',
        footer = 'Comment',
    }
end

---@alias AbelNotifyLevel "error"|"info"|"warn"|"warning"|"debug"|"trace"
---@alias AbelNotifyAnchor "NW"|"NE"|"SW"|"SE"
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
---@field relayout? boolean -- Recompute layout when reusing the same id
---@field size? AbelNotifySize
---@field row? number|string
---@field col? number|string
---@field anchor? AbelNotifyAnchor -- Anchor for row/col alignment

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
---@field win table
---@field buf integer
---@field timer? uv.uv_timer_t

---@param msg string
---@param opts AbelNotifyOpts
---@return AbelNotify
local function build_notif(msg, opts)
    return {
        msg = tostring(msg or ''),
        title = opts.title,
        icon = opts.icon or (opts.level and (opts.level == 'error' and ' ' or ' ')) or '',
        ft = opts.ft,
        id = opts.id,
        added = opts.added or os.time(),
        opts = opts.opts, -- optional function to mutate notif
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

---@param win table
---@param lines string[]
---@param pad number
---@return number width
---@return number height
---@return number wanted_height
local function compute_dims(win, lines, pad)
    local width = (win.border_text_width and win:border_text_width()) or 0
    for _, line in ipairs(lines) do
        width = math.max(width, vim.fn.strdisplaywidth(line) + pad)
    end
    width = dim(width, 40, 0.4, vim.o.columns)

    local height = #lines
    if win.opts.wo and win.opts.wo.wrap then
        height = 0
        for _, line in ipairs(lines) do
            height = height + math.ceil((vim.fn.strdisplaywidth(line) + pad) / width)
        end
    end
    local wanted_height = height
    height = dim(height, 1, 0.6, vim.o.lines)

    return width, height, wanted_height
end

---@param value number|AbelNotifyFlex|nil
---@param current number
---@param parent number
---@return number
local function resolve_size_value(value, current, parent)
    if type(value) == 'number' then
        if value >= 1 then
            return value
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

---@param size AbelNotifySize|nil
---@param width number
---@param height number
---@return number
---@return number
local function apply_size_override(size, width, height)
    if type(size) == 'table' then
        width = resolve_size_value(size.width, width, vim.o.columns)
        height = resolve_size_value(size.height, height, vim.o.lines)
    end
    return width, height
end

---@param win table
---@param opts AbelNotifyOpts
local function apply_position(win, opts)
    if opts.row ~= nil then
        win.opts.row = opts.row
    end
    if opts.col ~= nil then
        win.opts.col = opts.col
    end
    if opts.anchor ~= nil then
        win.opts.anchor = opts.anchor
    end
end

---@param win table
---@param border "none"|"top"|"right"|"bottom"|"left"|"top_bottom"|"hpad"|"vpad"|"rounded"|"single"|"double"|"solid"|"shadow"|"bold"|string[]|false|true|nil
local function apply_border(win, border)
    if border ~= nil then
        win.opts.border = border
    end
end

---@param win table
---@param wanted_height number
---@param height number
---@param opts AbelNotifyOpts
local function apply_footer(win, wanted_height, height, opts)
    if wanted_height > height and (win.has_border and win:has_border()) and opts.more_format and not win.opts.footer then
        win.opts.footer = opts.more_format and (opts.more_format:format(wanted_height - height)) or nil
        win.opts.footer_pos = 'right'
    end
end

---@param win table
---@param hl AbelNotifyHL
local function apply_winhighlight(win, hl)
    win.opts.wo = win.opts.wo or {}
    win.opts.wo.winhighlight = ('Normal:%s,NormalNC:%s,FloatBorder:%s,FloatTitle:%s,FloatFooter:%s'):format(
        hl.msg,
        hl.msg,
        hl.border,
        hl.title,
        hl.footer
    )
end

---@param win table
local function apply_conceal(win)
    win.opts.wo = win.opts.wo or {}
    win.opts.wo.conceallevel = 2
    win.opts.wo.concealcursor = 'n'
end

---@param win table
---@param state AbelNotifyState
---@param timeout number|false
local function reset_autoclose(win, state, timeout)
    if state.timer then
        pcall(state.timer.stop, state.timer)
        pcall(state.timer.close, state.timer)
        state.timer = nil
    end

    if timeout and timeout ~= 0 and timeout ~= false then
        local timer = uv.new_timer()
        state.timer = timer
        timer:start(timeout, 0, function()
            pcall(timer.stop, timer)
            pcall(timer.close, timer)
            state.timer = nil
            vim.schedule(function()
                if win and win:valid() then
                    pcall(function()
                        win:close()
                    end)
                end
            end)
        end)
    end
end

-- compact: border title + plain message lines
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

-- Generic render dispatcher
---@param buf integer
---@param notif AbelNotify
---@param ctx AbelNotifyCtx
---@param render AbelNotifyRender|nil
local function render_to_buf(buf, notif, ctx, render)
    -- allow dynamic opts hook like original
    if type(notif.opts) == 'function' then
        notif.opts(notif)
    end

    -- prepare hl and ctx
    ctx = ctx or {}
    ctx.ns = ctx.ns or NS
    ctx.opts = ctx.opts or {}
    ctx.hl = ctx.hl or default_hl()

    render = render or render_compact

    vim.bo[buf].modifiable = true
    -- clear extmarks in our ns and clear lines
    vim.api.nvim_buf_clear_namespace(buf, ctx.ns, 0, -1)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
    -- call chosen renderer
    render(buf, notif, ctx)
    vim.bo[buf].modifiable = false
end

---@param msg string
---@param opts AbelNotifyOpts|nil
---@param render AbelNotifyRender|nil
---@return table win
local function notify_like(msg, opts, render)
    opts = opts or {}
    local timeout = opts.timeout or 3000 -- ms
    local size = opts.size or {}
    local border = opts.border
    if border == nil then
        border = true
    end
    local hl = default_hl()

    local win
    local buf
    local state
    local reuse = false
    if opts.id then
        state = ACTIVE[opts.id]
        if state and state.win and state.win:valid() then
            win = state.win
            buf = state.buf
            reuse = true
        else
            ACTIVE[opts.id] = nil
            state = nil
        end
    end

    if not win then
        win = Snacks.win {
            style = 'notification',
            show = false,
            enter = false,
            backdrop = false,
            position = 'float',
            border = border,
            ft = opts.ft or 'markdown',
            noautocmd = true,
        }
        buf = win:open_buf()
        state = { win = win, buf = buf }
        if opts.id then
            ACTIVE[opts.id] = state
            win:on('WinClosed', function()
                if state.timer then
                    pcall(state.timer.stop, state.timer)
                    pcall(state.timer.close, state.timer)
                    state.timer = nil
                end
                if ACTIVE[opts.id] == state then
                    ACTIVE[opts.id] = nil
                end
            end, { win = true })
        else
            win:on('WinClosed', function()
                if state.timer then
                    pcall(state.timer.stop, state.timer)
                    pcall(state.timer.close, state.timer)
                    state.timer = nil
                end
            end, { win = true })
        end
    end

    -- build notif table similar to notifier
    local notif = build_notif(msg, opts)

    apply_border(win, border)

    -- render into buffer
    render_to_buf(buf, notif, { opts = win.opts, ns = NS, hl = hl }, render)

    if (not reuse) or opts.relayout == true then
        -- compute width/height similar to snacks.notifier: measure lines and pad
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        local pad = (true and (win.add_padding and win:add_padding() or 2) or 0)
        local width, height, wanted_height = compute_dims(win, lines, pad)
        width, height = apply_size_override(size, width, height)
        apply_position(win, opts)

        -- footer if truncated and border exists
        apply_footer(win, wanted_height, height, opts)

        -- set computed size on win.opts so win:show()/layout can use it
        win.opts.width = width
        win.opts.height = height

        -- Apply window highlights (simple setup)
        apply_winhighlight(win, hl)
        apply_conceal(win)
    end

    -- finally show
    win:show()

    -- auto close timer
    if state then
        reset_autoclose(win, state, timeout)
    else
        reset_autoclose(win, { win = win, buf = buf }, timeout)
    end

    return win
end

---@class AbelNotifyModule
---@field notify_like fun(msg: string, opts: AbelNotifyOpts|nil, render: AbelNotifyRender|nil): table

---@type AbelNotifyModule
return {
    notify_like = notify_like,
}
