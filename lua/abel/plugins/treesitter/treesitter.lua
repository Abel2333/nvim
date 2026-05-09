-- Hightlight, edit, and navigate code

---@type LazyPluginSpec
return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    opts = {
        parsers = {
            'bash',
            'c',
            'diff',
            'html',
            'lua',
            'luadoc',
            'markdown',
            'markdown_inline',
            'vim',
            'vimdoc',
            'python',
            'cpp',
            'yaml',
            'java',
        },
    },
    config = function(_, opts)
        require('nvim-treesitter.install').prefer_git = true
        require('nvim-treesitter').setup()
        require('nvim-treesitter').install(opts.parsers)

        vim.api.nvim_create_autocmd('FileType', {
            group = vim.api.nvim_create_augroup('abel-treesitter', { clear = true }),
            callback = function(args)
                pcall(vim.treesitter.start, args.buf)

                if vim.bo[args.buf].filetype ~= 'ruby' then
                    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })
    end,
}
