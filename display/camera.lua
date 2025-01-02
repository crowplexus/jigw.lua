--- @class Camera
local Camera = Class("Camera")

local transform = love.math.newTransform()

function Camera:init(x, y)
    self.position = Vec2(x or 0, y or 0) --- @type Vec2
    self.scale = Vec2(1, 1) --- @type Vec2
    self.rotation = 0 --- @type number
    self.zoom = Vec2(1, 1) --- @type Vec2
    self.color = {1, 1, 1, 1} --- @type table
    self.visible = true --- @type boolean
end

function Camera:getTransform() -- TODO: make objects be able to ignore camera transform
    local screenW, screenH = love.graphics.getDimensions()
    local currentX, currentY = self.position.x, self.position.y
    transform:reset()
    transform:translate(
        math.min(self.position.x, currentX + screenW * 0.5 * (self.scale.x / self.zoom.x)),
        math.max(self.position.y, currentY - screenH * 0.5 * (self.scale.y / self.zoom.y))
    )
    transform:rotate(self.rotation)
    transform:scale(self.scale.x, self.scale.y)
    return transform
end

return Camera