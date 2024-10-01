local function buildLabel(sel)
	sel.text = nil
	sel.fontSize = 14
	sel.fontPath = "assets/fonts/vcr.ttf"
	sel.position = Vector2(0,0)
	sel.zAsLayer = true
	sel.size = Vector2(0,0)
	sel.scale = Vector2(1,1)
	sel.strokeSize = 0
	sel.strokeColor = Color.BLACK
	sel.color = Color.WHITE
	sel.visible = true
	sel.rotation = 0
	sel.alpha = 1.0
	return sel
end

local Label = Object:extend() --- @class Label
function Label:__tostring() return "Label" end

local function _recreateFont(sel)
	if sel._renderFont then sel._renderFont:release() end
	sel._renderFont = love.graphics.newFont(sel.fontPath,sel.fontSize,"none")
end

local function _isFontPath(p)
	return p and type(p) == "string" and (p:sub(#".ttf") or p:sub(#".otf"))
end

function Label:new(x,y,text,size)
	buildLabel(self)
	self.position.x = x
	self.position.y = y
	self.text = text or nil
	self.fontSize = size or 14
	self._renderFont = nil
	self:changeFontSize(size,true)
end

function Label:dispose()
	self._renderFont:release()
	buildLabel(self)
end

function Label:draw()
	love.graphics.push()
	if not self:hasAnyText() or not self.visible then
		love.graphics.pop()
		return
	end
	local so = 0
	local sz = self.strokeSize
	if self.strokeSize > 0 then
		love.graphics.setColor(self.strokeColor)
		local tx = self.position.x
		local ty = self.position.y
		local tr = self.rotation
		local sx = self.scale.x
		local sy = self.scale.y
		so = sz
		for i=1,8 do
			love.graphics.print(self.text, self._renderFont, tx + sz, ty + sz + so, tr, sx, sy)
			love.graphics.print(self.text, self._renderFont, tx + sz + so, ty + sz, tr, sx, sy)
			love.graphics.print(self.text, self._renderFont, tx + sz - so, ty + sz + so, tr, sx, sy)
			love.graphics.print(self.text, self._renderFont, tx + sz + so, ty + sz - so, tr, sx, sy)
			so = -so
		end
	end
	love.graphics.setColor(self.color)
	love.graphics.print(self.text,self._renderFont,
	self.position.x+sz,self.position.y+sz,
	self.rotation,self.scale.x,self.scale.y)
	love.graphics.setColor(Color.WHITE)
	love.graphics.pop()
end

function Label:hasAnyText()
	return type(self.text) == "string" and string.len(self.text) ~= 0
end

function Label:changeFont(path)
	local fi = love.filesystem.getInfo(path)
	if _isFontPath(path) and fi and fi.size and self.fontPath ~= path then
		self.fontPath = path
		_recreateFont(self)
	end
end

function Label:changeFontSize(newSize, force)
	self.fontSize = newSize
	_recreateFont(self)
end

function Label:centerPosition(_x_)
	assert(_x_, "Axis value must be either Axis.X, Axis.Y, or Axis.XY")
	local vpw, vph = love.graphics.getDimensions()
	local centerX = _x_ == Axis.X
	local centerY = _x_ == Axis.Y
	if(_x_ == Axis.XY)then
		centerX = true
		centerY = true
	end
	if centerX then
		local width = self._renderFont:getWidth(self.text) or 0
		self.position.x = (vpw-width)* 0.5
	end
	if centerY then
		local height = self._renderFont:getHeight() or 0
		self.position.y = (vph-height)* 0.5
	end
end

--#region Getters and Setters
function Label:get_alpha() return self.color[4] end
function Label:set_alpha(vl) self.color[4] = vl end
--#endregion

return Label
