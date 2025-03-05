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
	--- Camera Area Limit: x, y, w, h (left, top, right, bottom)
	--- @type Rect2
	self.limit = Rect2(-1000000, -1000000, 1000000, 1000000)
	-- TODO ^: implement camera limit
end

function Camera:getTransform() -- TODO: make objects be able to ignore camera transform
	local screenW, screenH = love.graphics.getDimensions()
	local currentX, currentY = self.position.x, self.position.y
	local scaleX, scaleY = self.scale.x / self.zoom.x, self.scale.y / self.zoom.y
	transform:reset()
	currentX = math.max(self.limit.x, math.min(self.position.x, self.limit.w * scaleX))
	currentY = math.max(self.limit.y, math.min(self.position.y, self.limit.h * scaleY))
	transform:translate(self.rotateH and -currentX or 0, self.rotateV and -currentY or 0)
	transform:rotate(self.rotation)
	transform:scale(scaleX, scaleY)
	--print("x:"..currentX)
	--print("y:"..currentY)
	self.position.x, self.position.y = currentX, currentY
	return transform
end

return Camera