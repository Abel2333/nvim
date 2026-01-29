local uv = vim.uv or vim.loop

local function notify_like(msg, opts)
    opts = opts or {}
    local timeout = opts.timeout or 3000 -- 毫秒，0/false 表示不自动关闭

    -- 创建一个不立即显示的窗口（样式按需）
    local win = Snacks.win {
        style = 'notification',
        show = false,
        enter = false,
        backdrop = false,
        ft = 'markdown',
        noautocmd = true,
        keys = {
            q = function()
                win:close()
            end,
        },
    }

    -- 准备缓冲内容
    local buf = win:open_buf()
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(msg, '\n', { plain = true }))

    -- 显示窗口
    win:show()

    -- 如果不需要自动关闭，直接返回窗口
    if not timeout or timeout == 0 or timeout == false then
        return win
    end

    -- 创建一次性 uv timer
    local timer = uv.new_timer()
    timer:start(timeout, 0, function()
        -- 在回调里先停止并关闭 timer，再调度到主循环关闭窗口
        pcall(timer.stop, timer)
        pcall(timer.close, timer)
        vim.schedule(function()
            if win and win:valid() then
                win:close()
            end
        end)
    end)

    -- 在窗口关闭时清理 timer（防止泄漏或重复关闭）
    win:on('WinClosed', function()
        if timer then
            pcall(timer.stop, timer)
            pcall(timer.close, timer)
            timer = nil
        end
    end, { win = true })

    return win
end

-- 调用示例
notify_like('Hello world!', { timeout = 2500 })
