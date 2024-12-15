local Color = {}
Color.__index = Color

local rgb_to_hsi = function(R, G, B)
    -- Normalise the rgb
    local red = R / 255
    local green = G / 255
    local blue = B / 255

    -- Calculate the Intensity
    local intensity = (red + green + blue) / 3

    -- Caculate the Saturation
    local min_rgb = math.min(red, green, blue)
    local saturation = 0
    -- Black does not have saturation
    if intensity > 0 then
        saturation = 1 - (min_rgb / intensity)
    end

    -- Caculate the Hue, using the radian system
    local num = 0.5 * ((red - green) + (red - blue))
    local den = math.sqrt((red - green) * (red - green) + (red - blue) * (green - blue))
    -- To avoid divide zero and ensure within [-1, 1]
    local theta = math.acos(math.max(math.min(num / (den + 1e-12), 1), -1))

    local hue
    if blue <= green then
        hue = theta
    else
        hue = 2 * math.pi - theta
    end

    return hue, saturation, intensity
end

local hsi_to_rgb = function(hue, saturation, intensity)
    hue = hue % (2 * math.pi)

    local red, green, blue

    if hue >= 0 and hue < 2 * math.pi / 3 then
        -- When H in [0, 2π/3), it is below red
        blue = intensity * (1 - saturation)
        red = intensity * (1 + saturation * math.cos(hue) / math.cos(math.pi / 3 - hue))
        green = 3 * intensity - (red + blue)
    elseif hue >= 2 * math.pi / 3 and hue < 4 * math.pi / 3 then
        -- When H in [2π/3, 4π/3), it is below green
        hue = hue - 2 * math.pi / 3
        red = intensity * (1 - saturation)
        green = intensity * (1 + saturation * math.cos(hue) / math.cos(math.pi / 3 - hue))
        blue = 3 * intensity - (red + green)
    else
        -- When H in [4π/3, 2π), it is below blue
        hue = hue - 4 * math.pi / 3
        green = intensity * (1 - saturation)
        blue = intensity * (1 + saturation * math.cos(hue) / math.cos(math.pi / 3 - hue))
        red = 3 * intensity - (green + blue)
    end

    -- Convert to integers within [0, 255]
    red = math.max(0, math.min(255, math.floor(red * 255 + 0.5)))
    green = math.max(0, math.min(255, math.floor(green * 255 + 0.5)))
    blue = math.max(0, math.min(255, math.floor(blue * 255 + 0.5)))

    return red, green, blue
end

---@param pattern 'hex'|'value'
---@param value List
function Color:new(pattern, value)
    local color_instance
    if pattern == 'hex' then
        local rgb_hex = string.gsub(value[1], '#', '')

        local r = tonumber(rgb_hex:sub(1, 2), 16)
        local g = tonumber(rgb_hex:sub(3, 4), 16)
        local b = tonumber(rgb_hex:sub(5, 6), 16)

        color_instance = setmetatable({ red = r, green = g, blue = b }, self)
    elseif pattern == 'value' then
        color_instance = setmetatable({ red = value[1], green = value[2], blue = value[3] }, self)
    else
        error 'Invalid parameters for Color:new(). Expected hex string or RGB values within a list.'
    end
    return color_instance
end

function Color:__tostring()
    return string.format('RGB(%d, %d, %d)', self.red, self.green, self.blue)
end

function Color:get_darkened(factor)
    local hue, saturation, intensity = rgb_to_hsi(self.red, self.green, self.blue)

    intensity = intensity * (100 - factor) / 100

    local r, g, b = hsi_to_rgb(hue, saturation, intensity)
    return Color:new('value', { r, g, b })
end

function Color:get_lightened(factor)
    local hue, saturation, intensity = rgb_to_hsi(self.red, self.green, self.blue)

    intensity = math.min(intensity * (100 + factor) / 100, 1)

    local r, g, b = hsi_to_rgb(hue, saturation, intensity)
    return Color:new('value', { r, g, b })
end

function Color:get_desaturated(factor)
    local hue, saturation, intensity = rgb_to_hsi(self.red, self.green, self.blue)

    saturation = saturation * (100 - factor) / 100

    local r, g, b = hsi_to_rgb(hue, saturation, intensity)
    return Color:new('value', { r, g, b })
end

function Color:get_saturated(factor)
    local hue, saturation, intensity = rgb_to_hsi(self.red, self.green, self.blue)

    saturation = math.min(saturation * (100 + factor) / 100, 1)

    local r, g, b = hsi_to_rgb(hue, saturation, intensity)
    return Color:new('value', { r, g, b })
end

function Color:get_hsi()
    local h, s, i = rgb_to_hsi(self.red, self.green, self.blue)
    return string.format('Hue: %.3f, Saturation: %.3f, Intensity: %.3f', h, s, i)
end

function Color:get_hex()
    return string.format('#%02X%02X%02X', self.red, self.green, self.blue)
end

---Mix two colors
---@param ColorA table
---@param ColorB table
---@param rate float
function Color:get_mix(ColorA, ColorB, rate)
    local r = ColorA.red * rate + ColorB.red * (1 - rate)
    local g = ColorA.green * rate + ColorB.green * (1 - rate)
    local b = ColorA.blue * rate + ColorB.blue * (1 - rate)

    return Color:new('value', { r, g, b })
end

return Color
