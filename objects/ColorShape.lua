--- @enum ShapeType
ShapeType = {
	RECTANGLE = 1,
	CIRCLE = 2,
}

local ColorShape = Classic:extend("ColorShape") --- @class ColorShape

function ColorShape:construct(x, y, c, sx, sy)
	self.position = Vector2(x, y)
	self.cornerRadius = Vector2(0, 0)
	self.size = Vector2(sx or 50, sy or 50)
	self.color = c or Color.WHITE()
	self.shape = ShapeType.RECTANGLE
	self.visible = true
	self.centered = false
	self.rotation = 0
	self.alpha = 1.0
end

function ColorShape:dispose()
	self.position = nil
	self.cornerRadius = nil
	self.size = nil
	self.color = nil
	self.shape = nil
	self.visible = nil
	self.centered = nil
	self.rotation = nil
	self.alpha = nil
end

function ColorShape:draw()
	if not self.visible then
		return
	end
	love.graphics.push("all")
	love.graphics.setColor(self.color)
	Utils.match(self.shape, {
		[1] = function()
			local frW, frH = self.size:unpack()
			love.graphics.translate(self.position:unpack())
			love.graphics.rotate(self.rotation)
			if self.centered then
				love.graphics.translate(-frW * 0.5, -frH * 0.5)
			end
			love.graphics.rectangle("fill", 0, 0, self.size.x, self.size.y, self.cornerRadius.x, self.cornerRadius.y)
		end,
		[2] = function()
			--local frW, frH = self.size:unpack()
			love.graphics.translate(self.position:unpack())
			love.graphics.rotate(self.rotation)
			--if(self.centered)then
			--  love.graphics.translate(-frW * 0.5, -frH * 0.5)
			--end
			love.graphics.circle("fill", 0, 0, -self.size.x, self.size.y)
		end,
	})
	love.graphics.setColor(Color.WHITE())
	love.graphics.pop()
end

function ColorShape:centerPosition(_x_)
	assert(_x_, "Axis value must be either Axis.X, Axis.Y, or Axis.XY")
	local vpw, vph = love.graphics.getDimensions()
	local centerX = _x_ == Axis.X
	local centerY = _x_ == Axis.Y
	if _x_ == Axis.XY then
		centerX = true
		centerY = true
	end
	if centerX then
		self.position.x = vpw * 0.5
	end
	if centerY then
		self.position.y = vph * 0.5
	end
	self.centered = centerX == true or centerY == true
end

--#region Getters and Setters
function ColorShape:get_alpha()
	return self.color[4]
end
function ColorShape:set_alpha(vl)
	if self.color then
		self.color[4] = vl
	end
end
--#endregion

return ColorShape
