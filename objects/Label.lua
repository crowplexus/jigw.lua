local Label = Classic:extend("Label") --- @class Label
function Label:__tostring()
	return "Label"
end

local function _isFontPath(p)
	return p and type(p) == "string" and (p:sub(#".ttf") or p:sub(#".otf"))
end

local function _recreateFont(sel)
	if sel._renderFont then
		sel._renderFont:release()
	end
	if _isFontPath(sel.fontPath) and love.filesystem.getInfo(sel.fontPath).type == "file" then
		sel._renderFont = love.graphics.newFont(sel.fontPath, sel.fontSize, "light")
	else
		sel._renderFont = love.graphics.getFont()
	end
end

function Label:build(x, y, text, size)
	self.position = Vector2(x, y)
	self.size = Vector2(0, 0)
	self.scale = Vector2(1, 1)
	self.text = text or nil
	self.fontSize = size or 14
	self._renderFont = nil
	self.strokeSize = 0
	self.fontPath = nil
	self.color = Color.WHITE()
	self.strokeColor = Color.BLACK()
	self.visible = true
	self.rotation = 0
	rawset(self, "alpha", 1.0)
	self:changeFontSize(size, true)
end

function Label:dispose()
	if self._renderFont ~= nil then
		if self._renderFont.release then
			self._renderFont:release()
		end
		self._renderFont = nil
	end
	self.position = nil
	self.size = nil
	self.scale = nil
	self.text = nil
	self.fontSize = nil
	self._renderFont = nil
	self.strokeSize = nil
	self.fontPath = nil
	self.color = nil
	self.strokeColor = nil
	self.visible = nil
	self.rotation = nil
	self.alpha = nil
end

function Label:draw()
	if not self:hasAnyText() or not self.visible then
		return
	end
	local sz = self.strokeSize
	local drawStroke = function()
		local so = 0
		local tx = self.position.x
		local ty = self.position.y
		local tr = self.rotation
		local sx = self.scale.x
		local sy = self.scale.y
		so = sz
		love.graphics.setColor(self.strokeColor)
		for i = 1, 8 do -- not the greatest idea to use print here...
			love.graphics.print(self.text, self._renderFont, tx + sz, ty + sz + so, tr, sx, sy)
			love.graphics.print(self.text, self._renderFont, tx + sz + so, ty + sz, tr, sx, sy)
			love.graphics.print(self.text, self._renderFont, tx + sz - so, ty + sz + so, tr, sx, sy)
			love.graphics.print(self.text, self._renderFont, tx + sz + so, ty + sz - so, tr, sx, sy)
			so = -so
		end
	end
	if self.strokeSize > 0 then
		drawStroke()
	end
	love.graphics.setColor(self.color)
	love.graphics.print(
		self.text,
		self._renderFont,
		self.position.x + sz,
		self.position.y + sz,
		self.rotation,
		self.scale.x,
		self.scale.y
	)
end

function Label:hasAnyText()
	return type(self.text) == "string" and string.len(self.text) ~= 0
end

function Label:changeFontFromPath(path)
	self.fontPath = path
	_recreateFont(self)
end

function Label:changeFontSize(newSize, force)
	self.fontSize = newSize
	_recreateFont(self)
end

function Label:getWidth()
	return self._renderFont:getWidth(self.text) or 0
end

function Label:getHeight()
	return self._renderFont:getHeight() or 0
end

function Label:centerPosition(_x_)
	assert(_x_, "Axis value must be either Axis.X, Axis.Y, or Axis.XY")
	local vpw, vph = love.graphics.getDimensions()
	local centerX = _x_ == Axis.X
	local centerY = _x_ == Axis.Y
	if _x_ == Axis.XY then
		centerX = true
		centerY = true
	end
	if centerX then
		local width = self._renderFont:getWidth(self.text) or 0
		self.position.x = (vpw - width) * 0.5
	end
	if centerY then
		local height = self._renderFont:getHeight() or 0
		self.position.y = (vph - height) * 0.5
	end
end

--#region Getters and Setters
function Label:get_alpha()
	return self.color[4]
end
function Label:set_alpha(vl)
	if self.color then
		self.color[4] = vl
	end
end
--#endregion

return Label
