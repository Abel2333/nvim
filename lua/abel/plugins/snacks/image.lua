---A collection of small QoL plugins for Neovim
---@type LazyPluginSpec
return {
    'folke/snacks.nvim',
    opts = {
        ---@class snacks.image.Config
        image = {
            force = false, -- try displaying the image, even if the terminal does not support it
            doc = {
                -- enable image viewer for documents
                -- a treesitter parser must be available for the enabled languages.
                enabled = true,
                -- render the image inline in the buffer
                -- if your env doesn't support unicode placeholders, this will be disabled
                -- takes precedence over `opts.float` on supported terminals
                inline = false,
                -- render the image in a floating window
                -- only used if `opts.inline` is disabled
                float = true,
                max_width = 80,
                max_height = 40,
            },
            -- window options applied to windows displaying image buffers
            -- an image buffer is a buffer with `filetype=image`
            wo = {
                wrap = false,
                number = false,
                relativenumber = false,
                cursorcolumn = false,
                signcolumn = 'no',
                foldcolumn = '0',
                list = false,
                spell = false,
                statuscolumn = '',
            },
            -- icons used to show where an inline image is located that is
            -- rendered below the text.
            icons = {
                math = '󰍘 ',
                chart = '󰄧 ',
                image = ' ',
            },
            math = {
                enabled = true, -- enable math expression rendering
                -- in the templates below, `${header}` comes from any section in your document,
                -- between a start/end header comment. Comment syntax is language-specific.
                -- * start comment: `// snacks: header start`
                -- * end comment:   `// snacks: header end`
                typst = {
                    tpl = [[
        #set page(width: auto, height: auto, margin: (x: 2pt, y: 2pt))
        #show math.equation.where(block: false): set text(top-edge: "bounds", bottom-edge: "bounds")
        #set text(size: 12pt, fill: rgb("${color}"))
        ${header}
        ${content}]],
                },
                latex = {
                    font_size = 'small', -- see https://www.sascha-frank.com/latex-font-size.html
                    -- for latex documents, the doc packages are included automatically,
                    -- but you can add more packages here. Useful for markdown documents.
                    packages = { 'amsmath', 'amssymb', 'amsfonts', 'amscd', 'mathtools' },
                    tpl = [[
        \documentclass[preview,border=0pt,varwidth,12pt]{standalone}
        \usepackage{${packages}}
        \begin{document}
        ${header}
        { \${font_size} \selectfont
          \color[HTML]{${color}}
        ${content}}
        \end{document}]],
                },
            },
        },
    },
}
