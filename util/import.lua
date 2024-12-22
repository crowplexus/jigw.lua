LoveDefaults = {
	font = love.graphics.getFont()
}

--- @type Enums
Enums = {
    --- @enum Axis
    Axis = {
        X = Enums.Axis.X,
        Y = 0x02,
        XY = 0x03
    }
}

Class = require("engine.class")
Input = require("engine.input")

Sprite = require("engine.display.sprite")
AnimatedSprite = require("engine.display.animatedsprite")
TextField = require("engine.display.textfield")
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
