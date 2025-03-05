--- Basic Sprite class, can load a 2D texture and display it on the screen.
--- @class Sprite
local Sprite = Class("Sprite")
local transform = love.math.newTransform()

--- Creates a sprite.
--- @param x? number     X position of the Sprite.
--- @param y? number     Y position of the Sprite.
function Sprite:init(x, y)
	self.visible = true             --- @type boolean
	self.texture = nil              --- @type love.Image
	self.position = Vec2(x, y)      --- @type Vec2
	self.scale = Vec2(1, 1)         --- @type Vec2
	self.shear = Vec2(0, 0)         --- @type Vec2
	self.centered = Enums.Axis.NONE --- @type number
	self.color = { 1, 1, 1, 1 }     --- @type table<number>
	self.angle = 0                  --- @type number
	return self
end

--- Updates the sprite.
--- @param _ number  The time passed since the last frame.
function Sprite:update(_)
end

--- Draws the sprite.
function Sprite:draw()
	if self.texture and self.visible then
		love.graphics.push("all")
		if self.color then love.graphics.setColor(self.color) end
		transform:reset()
		transform:translate(self.position:unpack())
		transform:rotate(self.angle)
		transform:scale(self.scale:unpack())
		love.graphics.shear(self.shear:unpack())
		love.graphics.draw(self.texture, transform)
		if self.color then love.graphics.setColor(1, 1, 1, 1) end
		love.graphics.pop()
	end
end

--- Centers the Sprite to the canvas.
--- @param type number|Axis The axis to center the Sprite to.
--- @see Enums.Axis (utils/import.lua)
function Sprite:worldCenter(type)
	local x, y = love.graphics.getDimensions()
	local isX, isY = type == Enums.Axis.X, type == Enums.Axis.Y
	if type == Enums.Axis.XY then isX, isY = true, true end
	if isX then self.position.x = x * 0.5 end
	if isY then self.position.y = y * 0.5 end
	self.centered = type
end

--- Centers the Sprite to itself.
function Sprite:resetCenter()
	self.centered = Enums.Axis.NONE
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
