--- @class Sprite
local Sprite = Class("Sprite")
local transform = love.math.newTransform()

--- Creates a sprite.
--- @param x? number     X position of the Sprite.
--- @param y? number     Y position of the Sprite.
function Sprite:init(x, y)
    self.visible = true         --- @type boolean
    self.texture = nil          --- @type love.Image
    self.position = Vec2(x, y)  --- @type Vec2
    self.scale = Vec2(1, 1)     --- @type Vec2
    self.color = { 1, 1, 1, 1 } --- @type table<number>
    self.angle = 0              --- @type number
    return self
end

function Sprite:update(dt)
end

function Sprite:draw()
    if self.texture and self.visible then
        love.graphics.push("all")
        if self.color then love.graphics.setColor(self.color) end
        transform:reset()
        transform:translate(self.position:unpack())
        transform:rotate(self.angle)
        transform:scale(self.scale:unpack())
        love.graphics.draw(self.texture, transform)
        if self.color then love.graphics.setColor(1, 1, 1, 1) end
        love.graphics.pop()
    end
end

function Sprite:set_texture(nvl)
    if not nvl then return end
    if self.texture ~= nil then
        self.texture:release()
        self.texture = nil
    end
    self.texture = nvl
end

return Sprite
