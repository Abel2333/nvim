local custom = require 'abel.config.custom'

---@type LazyPluginSpec
return {
    'Robitx/gp.nvim',
    cond = vim.env.ENABLE_AI ~= nil,
    enabled = false,
    opts = {
        toggle_target = 'split',
        style_chat_finder_border = custom.broder,
        style_popup_border = custom.broder,
        providers = {
            deepseek = {
                disable = false,
                endpoint = 'https://api.deepseek.com/chat/completions',
                secret = vim.env.DEEPSEEK_API_KEY,
            },
        },
        curl_params = {
            '-N',
            '-X',
            'POST',
            '-H',
            'Content-Type: application/json',
            '-H',
            '-d',
            '--ssl-no-revoke',
        },
        agents = {
            {
                provider = 'deepseek',
                name = 'DeepSeekChat',
                chat = true,
                command = true,
                model = { model = 'deepseek-chat', temperature = 1.1, top_p = 1 },
                system_prompt = 'You are a general AI assistant.',
            },
        },
    },
    cmd = {
        -- Chat
        'GpChatNew',
        'GpChatToggle',
        'GpChatFinder',
    },
    keys = {
        -- Chat
        {
            '<C-g>c',
            '<Cmd>GpChatNew split<CR>',
            mode = { 'n', 'i' },
            desc = 'New Chat',
        },
        {
            '<C-g>c',
            ":<C-u>'<,'>GpChatNew split<CR>",
            mode = { 'v' },
            desc = 'New Chat',
        },
        {
            '<C-g>t',
            '<Cmd>GpChatToggle split<CR>',
            mode = { 'n', 'i' },
            desc = 'Toggle Chat',
        },
        {
            '<C-g>t',
            ":<C-u>'<,'>GpChatToggle split<CR>",
            mode = { 'v' },
            desc = 'Toggle Chat',
        },
        {
            '<C-g>f',
            '<Cmd>GpChatFinder<CR>',
            mode = { 'n', 'i' },
            desc = 'Find Chat',
        },
        {
            '<C-g>p',
            ":<C-u>'<,'>GpChatPaste<CR>",
            mode = { 'v' },
            desc = 'Chat Paste',
        },
    },
}
