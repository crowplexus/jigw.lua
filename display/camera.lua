--- @class Camera
local Camera = Class("Camera")

local transform = love.math.newTransform()

function Camera:init(x, y)
    self.position = Vec2(x or 0, y or 0) --- @type Vec2
    self.scale = Vec2(1, 1) --- @type Vec2
    self.rotation = 0 --- @type number
    self.zoom = Vec2(1, 1) --- @type Vec2
    self.color = {1, 1, 1, 1} --- @type table
    self.rotateH = true --- @type boolean
    self.rotateV = true --- @type boolean
    --- Camera Limit Rectangle: Left, Right, Top, Bottom
    --- @type Rect2
    self.limit = Rect2(-1000000, -1000000, 1000000, 1000000)
    -- TODO ^: implement camera limit
end

function Camera:getTransform() -- TODO: make objects be able to ignore camera transform
    local screenW, screenH = love.graphics.getDimensions()
    local currentX, currentY = self.position.x, self.position.y
    local scaleX, scaleY = math.abs(self.scale.x / self.zoom.x), math.abs(self.scale.y / self.zoom.y)
    transform:reset()
    transform:translate(
        self.rotateH and math.min(currentX, (currentX + screenW) * 0.5 * scaleX) or 0,
        self.rotateV and math.max(currentY, (currentY - screenH) * 0.5 * scaleY) or 0
    )
    transform:rotate(self.rotation)
    transform:scale(scaleX, scaleY)
    return transform
end

return Camera