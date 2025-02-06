local locals = require 'abel.config.locals'

---@type LazyPluginSpec
return {
    'Kurama622/llm.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',
    },
    cond = vim.env.ENABLE_AI ~= nil,
    cmd = { 'LLMSessionToggle', 'LLMSelectedTextHandler', 'LLMAppHandler' },
    opts = function()
        local misc_uitl = require 'abel.util.misc'
        local tools = require 'llm.common.tools'

        local win_args = [[
            return {url,
            "-N",
            "-X",
            "POST",
            "-H", 
            "Content-Type: application/json",
            "-H",
            authorization,
            "-d",
            vim.fn.json_encode(body),
            "--ssl-no-revoke"
            }
        ]]
        local nix_arg = [[
            return {url,
            "-N",
            "-X",
            "POST",
            "-H", 
            "Content-Type: application/json",
            "-H",
            authorization,
            "-d",
            vim.fn.json_encode(body),
            "--ssl-no-revoke"
            }
        ]]

        local options = {
            prompt = 'You are a helpful Chinese assistant.',

            url = 'https://api.deepseek.com/chat/completions',
            model = 'deepseek-chat',
            api_type = 'openai',
            args = misc_uitl.is_win() and win_args or nix_arg,
            max_tokens = 4096,
            temperature = 0.3,
            top_p = 0.7,

            prefix = {
                user = { text = '  ', hl = 'Title' },
                assistant = { text = '  ', hl = 'Added' },
            },

            save_session = true,
            max_history = 15,
            max_history_name_length = 20,

            style = 'float',

            spinner = {
                text = {
                    '󰧞󰧞',
                    '󰧞󰧞',
                    '󰧞󰧞',
                    '󰧞󰧞',
                },
                hl = 'Title',
            },

            app_handler = {
                WordTranslate = {
                    handler = tools.flexi_handler,
                    prompt = [[
                        You are an expert in Chinese-English translation, translating user input from Chinese to English, or from English to Chinese.
                        For non-Chinese content, you will provide the Chinese translation result.
                        Users can send content to the assistant for translation, and the assistant will respond with the corresponding translation result, ensuring that it conforms to Chinese linguistic habits.
                        You can adjust the tone and style and consider cultural connotations and regional differences of certain terms.
                        As a translator, you need to translate the original text in accordance with the principles of "faithfulness, expressiveness, and elegance."
                        "Faithfulness" means being faithful to the content and intent of the original text; "expressiveness" means the translation should be smooth, easy to understand, and clearly expressed; "elegance" means pursuing cultural aesthetic and linguistic beauty in the translation.
                        The goal is to create a translation that is both faithful to the spirit of the original work and in line with the target language's culture and reader's aesthetic appreciation.
                    ]],
                    opts = {
                        fetch_key = function()
                            return locals.switch_api 'siliconflow'
                        end,
                        url = 'https://api.siliconflow.cn/v1/chat/completions',
                        model = 'Qwen/Qwen2.5-7B-Instruct',
                        api_type = 'zhipu',
                        args = misc_uitl.is_win() and win_args or nix_arg,
                        exit_on_move = true,
                        enter_flexible_window = false,
                    },
                },
                CodeExplain = {
                    handler = tools.flexi_handler,
                    prompt = 'Explain the following code, and explain what features have been accomplished, please only return the explanation. Answer in Chinese',
                    opts = {
                        fetch_key = function()
                            return locals.switch_api 'deepseek'
                        end,
                        url = 'https://api.deepseek.com/chat/completions',
                        model = 'deepseek-reasoner',
                        api_type = 'zhipu',
                        args = misc_uitl.is_win() and win_args or nix_arg,
                        enter_flexible_window = true,
                    },
                },
            },

            keys = {
                -- The keyboard mapping for the input window.
                ['Input:Submit'] = { mode = 'n', key = '<C-g>' },
                ['Input:Cancel'] = { mode = { 'n', 'i' }, key = '<C-c>' },
                ['Input:Resend'] = { mode = { 'n', 'i' }, key = '<C-r>' },

                -- Only works when "save_session = true"
                ['Input:HistoryNext'] = { mode = { 'n', 'i' }, key = '<C-n>' },
                ['Input:HistoryPrev'] = { mode = { 'n', 'i' }, key = '<C-p>' },

                -- The keyboard mapping for the output window in "split" style.
                ['Output:Ask'] = { mode = 'n', key = 'i' },
                ['Output:Cancel'] = { mode = 'n', key = '<C-c>' },
                ['Output:Resend'] = { mode = 'n', key = '<C-r>' },

                -- The keyboard mapping for the output and input windows in "float" style.
                ['Session:Toggle'] = { mode = 'n', key = '<leader>ac' },
                ['Session:Close'] = { mode = 'n', key = { '<ESC>', 'q' } },

                -- Focus
                ['Focus:Input'] = { mode = 'n', key = { 'i' } },
                ['Focus:Output'] = { mode = { 'n', 'i' }, key = '<C-o>' },
            },
        }

        return options
    end,
    config = function(_, opts)
        vim.fn.setenv('LLM_KEY', locals.switch_api 'deepseek')

        require('llm').setup(opts)
    end,
    keys = {
        { '<leader>ac', mode = 'n', '<Cmd>LLMSessionToggle<CR>', desc = 'Chat' },
        { '<leader>ae', mode = 'v', '<Cmd>LLMAppHandler CodeExplain<CR>', desc = 'Explain Code' },
        { '<leader>at', mode = 'x', '<Cmd>LLMAppHandler WordTranslate<CR>', desc = 'Translate' },
    },
}
