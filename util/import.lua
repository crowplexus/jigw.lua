LoveDefaults = {
	font = love.graphics.getFont(),
    gfx = love.graphics,
    audio = love.audio,
}

local function mkReadOnlyTbl(tbl)
    if type(tbl) == "table" then
        local mt = {
            __mode = "k", -- weak keys
            __index = function(_, k)
                -- recursion, yay!
                return mkReadOnlyTbl(tbl[k])
            end,
            __newindex = function(t, k, v)
                error("Attempt to update a read-only table, key "..tostring(k).." with value "..tostring(v), 2)
            end,
        }
        return setmetatable({}, mt)
    else
        return tbl
    end
end
--- @type Enums
Enums = mkReadOnlyTbl({
    Axis = {
        NONE = 0x00,
        X = 0x01,
        Y = 0x02,
        XY = 0x03
    },
})

Class = require("engine.class")
Input = require("engine.input")

ScreenManager = require("engine.screenmanager")

Sprite = require("engine.display.sprite")
AnimatedSprite = require("engine.display.animatedsprite")
TextField = require("engine.display.textfield")
Camera = require("engine.display.camera")
Canvas = require("engine.display.canvas")
Screen = require("engine.display.screen")

Sound = require("engine.util.sound")

Vec2 = require("engine.util.math.vec2")
Vec3 = require("engine.util.math.vec3")

Rect2 = require("engine.util.math.rect2")
Rect3 = require("engine.util.math.rect3")

GlobalUpdate = function(dt)
    if Input.update and Input.globalUpdate then Input.update(dt) end
    if Sound.update and Sound.globalUpdate then Sound.update(dt) end
end
