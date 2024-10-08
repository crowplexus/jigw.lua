local Sprite = Object:extend() --- @class Sprite
function Sprite:__tostring() return "Sprite" end

function Sprite:new(x,y,tex)
	self.position = Vector2(x,y) -- X, Y
	self.scale = Vector2(1,1)
	self.color = Color.WHITE()
	self.visible = true
	self.centered = false;
	self.texture = tex or nil
	self.rotation = 0
	self.alpha = 1.0
end

function Sprite:dispose()
	if self.texture ~= nil then
		self.texture:release()
		self.texture = nil
	end
	self.position = nil
	self.scale = nil
	self.color = nil
	self.visible = nil
	self.centered = nil;
	self.texture = nil
	self.rotation = nil
	self.alpha = nil
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
	--love.graphics.setColor(Color.WHITE())
	love.graphics.pop()
end

--#region Getters and Setters
function Sprite:get_alpha()
	return self.color[4]
end
function Sprite:set_alpha(vl)
	if self.color then self.color[4] = vl end
end
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
