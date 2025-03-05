--- @class TextField
local TextField = Class("TextField")

--- Creates a new text field with the given text.
--- @param x? number     X position of the text field.
--- @param y? number     Y position of the text field.
--- @param text? string Text to display.
function TextField:init(x, y, text, fieldWidth)
	self.text = text or ""                   --- @type string
	self.visible = true                      --- @type boolean
	self.font = nil                          --- @type love.Font
	self.position = Vec2(x, y)               --- @type Vec2
	self.tint = { 1, 1, 1, 1 }               --- @type table<number>
	self.shear = Vec2(0, 0)                  --- @type Vec2
	self.centered = Enums.Axis.NONE          --- @type number
	self.fieldEnd = fieldWidth or love.graphics.getWidth()			 --- @type number
	self.alignment = "left"                  --- @type "left"|"center"|"right"
	return self
end

--- Updates the text field.
--- @param _ number  The time passed since the last frame.
function TextField:update(_)
end

function TextField:draw()
	if not self.visible or #self.text == 0 then
		return
	end
	love.graphics.push("all")
	if self.tint then love.graphics.setColor(self.tint) end
	if self.font then love.graphics.setFont(self.font) end
	love.graphics.shear(self.shear:unpack())
	love.graphics.printf(self.text, self.position.x, self.position.y, self.fieldEnd, self.alignment)
	if self.tint then love.graphics.setColor(1, 1, 1, 1) end
	if self.font then love.graphics.setFont(LoveDefaults.font) end
	love.graphics.pop()
end

--- Centers the Text Field to the canvas.
--- @param type number|Axis The axis to center the Text Field to.
--- @see Enums.Axis (utils/import.lua)
function TextField:worldCenter(type)
	local x, y = love.graphics.getDimensions()
	local isX, isY = type == Enums.Axis.X, type == Enums.Axis.Y
	if type == Enums.Axis.XY then isX, isY = true, true end
	if isX then self.position.x = x * 0.5 end
	if isY then self.position.y = y * 0.5 end
	self.centered = type
end

--- Centers the Text Field to itself.
function TextField:resetCenter()
	self.centered = Enums.Axis.NONE
end

function TextField:set_font(nvl)
	if not nvl then return end
	if self.font ~= nil then
		self.font:release()
		self.font = nil
	end
	self.font = nvl
end

return TextField
