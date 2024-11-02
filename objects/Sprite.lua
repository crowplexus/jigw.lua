local Sprite = Classic:extend("Sprite") --- @class Sprite

function Sprite:construct(x, y, tex)
	self.position = Vector2(x, y) -- X, Y
	self.scale = Vector2(1, 1)
	self.color = Color.WHITE()
	self.visible = true
	self.centered = false
	self.texture = tex or nil
	self.rotation = 0
	self.alpha = 1.0

	self.quads = {}
	self.frame = 1
	rawset(self, "hframes", 1) -- skip setter
	rawset(self, "vframes", 1) -- skip setter
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
	self.centered = nil
	self.texture = nil
	self.rotation = nil
	self.alpha = nil
end

local function shouldRenderQuad(sprite)
	local h, v = sprite.hframes or 1, sprite.vframes or 1
	local possible = h > 1 or v > 1
	return sprite.quads ~= nil and #sprite.quads ~= 0 and possible
end

local function generateQuads(tex, width, height, hf, vf)
	local quads = {}
	for h = 0, hf - 1, 1 do
		for v = 0, vf - 1, 1 do
			local x = width / vf * v
			local y = height / hf * h
			table.insert(quads, love.graphics.newQuad(x, y, w, h, tex))
		end
	end
	print("test, how many quads? " .. #quads)
	return quads
end

function Sprite:draw()
	if not self.texture or self.visible ~= true then
		return
	end
	love.graphics.push("all")
	love.graphics.setColor(self.color)
	local frW, frH = self.texture:getDimensions()
	love.graphics.translate(self.position:unpack())
	love.graphics.rotate(self.rotation)
	love.graphics.scale(self.scale.x, self.scale.y) --- this is what fixed it i think loll
	if self.centered then
		love.graphics.translate(-frW * 0.5, -frH * 0.5)
	end
	if shouldRenderQuad(self) == false then
		love.graphics.draw(self.texture, 0, 0)
	elseif self.quads[self.frame] ~= nil then
		love.graphics.draw(self.quads[self.frame], 0, 0)
	end
	--love.graphics.setColor(Color.WHITE())
	love.graphics.pop()
end

function Sprite:getWidth()
	return self.texture:getWidth() or 0
end
function Sprite:getHeight()
	return self.texture:getHeight() or 0
end
function Sprite:getDimensions()
	return self.texture:getWidth() or 0, self.texture:getHeight() or 0
end

function Sprite:centerPosition(_x_)
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

function Sprite:get_alpha()
	return self.color[4]
end

function Sprite:set_alpha(vl)
	if self.color then
		self.color[4] = vl
	end
end

function Sprite:set_hframes(vl)
	if vl < 2 then
		--print("hframes are less than 2, rendering texture...")
		return rawset(self, "hframes", vl)
	end
	if self.quads and #self.quads ~= 0 then
		for idx = 1, #self.quads do
			self.quads[idx]:release()
		end
	end
	rawset(self, "hframes", vl)
	local width, height = self:getDimensions()
	self.quads = generateQuads(self.texture, width, height, self.hframes, self.vframes)
end

function Sprite:set_vframes(vl)
	if vl < 2 then
		--print("vframes are less than 2, rendering texture...")
		return rawset(self, "vframes", vl)
	end
	if self.quads and #self.quads ~= 0 then
		for idx = 1, #self.quads do
			self.quads[idx]:release()
		end
	end
	rawset(self, "vframes", vl)
	local width, height = self:getDimensions()
	self.quads = generateQuads(self.texture, width, height, self.hframes, self.vframes)
end

return Sprite
