local Color = require 'abel.util.core.color'
local M = {}

M.Neorange = (function()
    local color_map = {
        [[              BBBBBBBBBBBB]],
        [[          BBBBOOOOOOOOOOOOBBBB]],
        [[      BBBBOOOOLLSSSSLLLLLLLLLLBBBB]],
        [[    BBOOOOLLLLOOOOOOOOOOOOOOOOOOOOBB]],
        [[    BBOOLLOOOOOOOOOOOOOOOOOOOOOOOOBB]],
        [[  BBPPSSOOOOOOOOSSOOOOOOOOUUOOOOOOOOBB]],
        [[  BBPPOOOOOOOOOOOOOOOOOOUUUUOOOOSSOOBB]],
        [[BBPPMMOOOOLLOOSSOOOOUUUUGGGGUUUUOOOOOOBB]],
        [[BBPPRROOOOOOOOLLOOOOOOUUUUGGUUOOOOOOOOBB]],
        [[BBPPRRMMOOSSLLLLLLSSOOOORRUUUUOOOOOOOOBB]],
        [[BBPPRRRROOOOOOLLOOOOOOOOOOUUOOOOOOMMOOBB]],
        [[BBPPRRRRMMOOOOSSOOOOOOOOOOOOOOOOOOOOOOBB]],
        [[BBPPRRRRRRMMOOOOOOOOOOOOOOOOMMOOOOOOOOBB]],
        [[  BBPPRRRRRRMMOOOOOOOOOOOOOOOOOOMMOOBB]],
        [[  BBPPRRPPRRRRRRMMOOOOOOOOOOOOOOOOOOBB]],
        [[    BBRRPPPPPPRRRRMMMMMMOOOOOOOOOOBB]],
        [[    BBRRPPPPPPPPRRRRRRRRMMMMMMMMMMBB]],
        [[      BBBBPPPPPPPPPPRRRRRRRRMMBBBB]],
        [[          BBBBPPPPPPPPPPRRBBBB]],
        [[              BBBBBBBBBBBB]],
    }

    local brown = Color:new('hex', { '#663931' })
    local orange = Color:new('hex', { '#F89901' })
    local pink = Color:new('hex', { '#CB8475' })
    local red = pink:get_saturated(127):get_darkened(14)
    local purpel = Color:new('hex', { '#59464B' })
    local green = Color:new('hex', { '#55aa70' })

    local colors = {
        ['B'] = { fg = brown:get_hex() },
        ['O'] = { fg = orange:get_hex() },
        ['L'] = { fg = orange:get_desaturated(20):get_lightened(40):get_hex() },
        ['S'] = { fg = orange:get_desaturated(10):get_lightened(20):get_hex() },
        ['U'] = { fg = purpel:get_hex() },
        ['G'] = { fg = green:get_hex() },
        ['P'] = { fg = pink:get_hex() },
        ['R'] = { fg = red:get_hex() },
        ['M'] = { fg = Color:get_mix(red, orange, 0.5):get_hex() },
    }

    return { color_map, colors }
end)()

M.NeoBee = (function()
    local color_map = {
        [[      AAAA]],
        [[AAAAAA  AAAA]],
        [[AA    AAAA  AAAA        KKHHKKHHHH]],
        [[AAAA    AAAA  AA    HHBBKKKKKKKKKKKKKK]],
        [[  AAAAAA      AAKKBBHHKKBBYYBBKKKKHHKKKKKK]],
        [[      AAAA  BBAAKKHHBBBBKKKKBBYYBBHHHHKKKKKK]],
        [[        BBAABBKKYYYYHHKKYYYYKKKKBBBBBBZZZZZZ]],
        [[    YYBBYYBBKKYYYYYYYYYYKKKKBBKKAAAAZZOOZZZZ]],
        [[    XXXXYYYYBBYYYYYYYYBBBBBBKKKKBBBBAAAAZZZZ]],
        [[    XXXXUUUUYYYYBBYYYYYYBBKKBBZZOOAAZZOOAAAAAA]],
        [[  ZZZZZZXXUUXXXXYYYYYYYYBBAAAAZZOOOOAAOOZZZZAAAA]],
        [[  ZZUUZZXXUUUUXXXXUUXXFFFFFFFFAAAAOOZZAAZZZZ  AA]],
        [[    RRRRUUUUZZZZZZZZXXOOFFFFOOZZOOAAAAAAZZZZAA]],
        [[    CCSSUUUUZZXXXXZZXXOOFFFFOOZZOOOOZZOOAAAA]],
        [[    CCCCUUUUUUUUUURRRROOFFFFOOZZOOOOZZOOZZZZ]],
        [[    CCCCUUUUUUUUSSCCCCEEQQQQOOZZOOOOZZOOZZZZ]],
        [[    CCCCUUGGUUUUCCCCCCEEQQQQOOZZOOOOZZEEZZ]],
        [[    RRRRGGGGUUGGCCCCCCOOOOOOOOZZOOEEZZII]],
        [[      IIRRGGGGGGCCCCCCOOOOOOOOZZEEII]],
        [[            GGRRCCCCCCOOOOEEEEII  II]],
        [[                RRRRRREEEE  IIII]],
        [[                      II]],
        [[]],
    }

    local yellow = Color:new('hex', { '#FAC87C' })
    local orange = Color:new('hex', { '#BF854E' })
    local maroon = Color:new('hex', { '#502E2B' })
    local brown = Color:new('hex', { '#38291B' })
    local rosewater = Color:new('hex', { '#F5E0DC' })
    local crust = Color:new('hex', { '#11111B' })
    local mantle = Color:new('hex', { '#181825' })
    local steelblue = Color:new('hex', { '#B3BCDF' })

    local colors = {
        ['A'] = { fg = rosewater:get_hex() },
        ['Y'] = { fg = yellow:get_hex() },
        ['B'] = { fg = yellow:get_darkened(5):get_hex() },
        ['X'] = { fg = yellow:get_darkened(20):get_hex() },
        ['U'] = { fg = yellow:get_darkened(25):get_hex() },
        ['F'] = { fg = yellow:get_darkened(35):get_hex() },
        ['O'] = { fg = yellow:get_darkened(45):get_hex() },
        ['K'] = { fg = maroon:get_hex() },
        ['H'] = { fg = maroon:get_darkened(10):get_hex() },
        ['Z'] = { fg = crust:get_hex() },
        ['G'] = { fg = yellow:get_darkened(25):get_hex() },
        ['R'] = { fg = orange:get_hex() },
        ['Q'] = { fg = orange:get_darkened(20):get_hex() },
        ['E'] = { fg = orange:get_darkened(35):get_hex() },
        ['I'] = { fg = brown:get_hex() },
        ['C'] = { fg = mantle:get_hex() },
        ['S'] = { fg = steelblue:get_hex() },
    }

    return { color_map, colors }
end)()

return M
