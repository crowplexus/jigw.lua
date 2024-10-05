--- @enum ShapeType
ShapeType = {
  RECTANGLE = 1,
  CIRCLE    = 2,
}

local ColorShape = Object:extend() --- @class ColorShape
local function buildColorShape(sel)
  sel.position = Vector2(0,0)
  sel.size = Vector2(0,0)
  sel.color = Color.WHITE
  sel.shape = ShapeType.RECTANGLE
  sel.visible = true
  sel.centered = false
  sel.rotation = 0
  return sel
end

function ColorShape:new(x,y,c,sx,sy)
  buildColorShape(ColorShape)
  if type(c) ~= "table" then c = Color.WHITE end
  self.position = Vector2(x,y)
  self.size = Vector2(sx or 50,sy or 50)
  self.color = c
  return self
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
			if(self.centered)then
				love.graphics.translate(-frW * 0.5, -frH * 0.5)
			end
			love.graphics.rectangle("fill",0,0,self.size.x,self.size.y)
		end,
		[2] = function()
			--local frW, frH = self.size:unpack()
			love.graphics.translate(self.position:unpack())
			love.graphics.rotate(self.rotation)
			--if(self.centered)then
			--  love.graphics.translate(-frW * 0.5, -frH * 0.5)
			--end
			love.graphics.circle("fill",0,0,-self.size.x,self.size.y)
		end,
	})
	--love.graphics.setColor(Color.WHITE)
	love.graphics.pop()
end

function ColorShape:centerPosition(_x_)
	assert(_x_, "Axis value must be either Axis.X, Axis.Y, or Axis.XY")
	local vpw, vph = love.graphics.getDimensions()
	local centerX = _x_ == Axis.X
	local centerY = _x_ == Axis.Y
	if(_x_ == Axis.XY)then
		centerX = true
		centerY = true
	end
	if centerX then self.position.x = vpw* 0.5 end
	if centerY then self.position.y = vph* 0.5 end
  self.centered = centerX == true or centerY == true
end

return ColorShape
