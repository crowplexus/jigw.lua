local Sprite = Object:extend() --- @class Sprite
function Sprite:__tostring() return "Sprite" end
local function buildSprite(sel)
	sel.position = Vector2(0,0) -- X, Y
	sel.scale = Vector2(1,1)
	sel.color = Color.WHITE
	sel.visible = true
	sel.centered = false;
	sel.texture = nil
	sel.rotation = 0
	sel.alpha = 1.0
	return sel
end

function Sprite:new(x,y,tex)
	buildSprite(self)
	self.position.x = x
	self.position.y = y
	if tex then self.texture = tex end
end

function Sprite:dispose()
	if self.texture ~= nil then
		self.texture:release()
		self.texture = nil
	end
end

function Sprite:draw()
	if not self.texture or not self.visible then
		return
	end
	love.graphics.push("all")
	love.graphics.setColor(self.color)
	local frW, frH = self.texture:getDimensions()
	love.graphics.translate(self.position:unpack())
	love.graphics.rotate(self.rotation)
	love.graphics.scale(self.scale.x,self.scale.y); --- this is what fixed it i think loll
	if(self.centered)then
		love.graphics.translate(-frW * 0.5, -frH * 0.5)
	end
	love.graphics.draw(self.texture,0,0)
	--love.graphics.setColor(Color.WHITE)
	love.graphics.pop()
end

--#region Getters and Setters
function Sprite:get_alpha() return self.color[4] end
function Sprite:set_alpha(vl) self.color[4] = vl end
--#endregion

function Sprite:centerPosition(_x_)
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

return Sprite
