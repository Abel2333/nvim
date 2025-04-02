---@type LazyPluginSpec
return {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
        vim.fn['mkdp#util#install']()
    end,
    config = function()
        -- Set to 1 to allow preview server available to
        -- others in network
        vim.g.mkdp_open_to_the_world = 1
        vim.g.mkdp_open_ip = '127.0.0.1'
        vim.g.mkdp_port = 8080
        -- Specify browser to open preview page
        vim.g.mkdp_brower = 'none'
        -- Set to 1 to echo preview page URL in command line
        vim.g.mkdp_echo_preview_url = 1
    end,
}
