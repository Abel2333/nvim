local bit = require 'bit'

local M = {}

local _base_wall_ms = os.time() * 1000
local _base_mono_ms = math.floor(vim.uv.hrtime() / 1e6)
local _last_ms = 0

local function unix_ms()
    local now = _base_wall_ms + (math.floor(vim.uv.hrtime() / 1e6) - _base_mono_ms)
    if now < _last_ms then
        now = _last_ms
    end
    _last_ms = now
    return now
end

local function bytes_to_uuid(bytes)
    return string.format(
        '%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x',
        bytes[1],
        bytes[2],
        bytes[3],
        bytes[4],
        bytes[5],
        bytes[6],
        bytes[7],
        bytes[8],
        bytes[9],
        bytes[10],
        bytes[11],
        bytes[12],
        bytes[13],
        bytes[14],
        bytes[15],
        bytes[16]
    )
end

function M.uuidv7()
    local ms = unix_ms()
    local random = { string.byte(vim.uv.random(10), 1, 10) }
    local bytes = {}

    for i = 6, 1, -1 do
        bytes[i] = ms % 256
        ms = math.floor(ms / 256)
    end

    for i = 1, 10 do
        bytes[6 + i] = random[i]
    end

    bytes[7] = bit.bor(bit.band(bytes[7], 0x0F), 0x70)
    bytes[9] = bit.bor(bit.band(bytes[9], 0x3F), 0x80)

    return bytes_to_uuid(bytes)
end

return M
