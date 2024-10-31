--- Contains fields to define which direction the bar foreground goes to
--- @enum ProgressFill
ProgressFill = {
	LTR = 0, --- @type number Left to Right
	RTL = 1, --- @type number Right to Left
	TTB = 2, --- @type number Top to Bottom
	BTT = 3, --- @type number Bottom to Top
}

--- Used for a visual representation of a percentage.
local ProgressShape = Classic:extend("ProgressShape") --- @class ProgressShape
function ProgressShape:__tostring()
	return "ProgressShape"
end

function ProgressShape:build(x, y, w, h, colors)
	if colors == nil or #colors < 2 then
		colors = { Color.WHITE(), Color.BLACK() }
	end
	self.position = Vector2(x, y) --- @class Vector2
	self.size = Vector2(w or 590, h or 10) --- @class Vector2
	self.colors = colors --- @type table
	self.rotation = 0 --- @type number
	self.centered = false --- @type boolean
	self.visible = true --- @type boolean
	self.border = { width = 10, Color = Color.BLACK() } --- @type table<number,table>
	self.minPercent = 0 --- @type number minimum percentage value, by default, set to 0
	self.maxPercent = 100 --- @type number maximum percentage value, by default, set to 100
	self.percentage = 0 --- @type number percentage of the progress bar, ranging from 0 to `self.maxValue`
	self.fillMode = ProgressFill.LTR --- @type ProgressFill|number used to denominate where the progress Color of the bar should go
	self.shape = ShapeType.RECTANGLE --- @type ShapeType|number Type of shape that the progress shape will display as.
	return self
end

function ProgressShape:dispose()
	self.position = nil
	self.size = nil
	self.colors = nil
	self.rotation = nil
	self.centered = nil
	self.visible = nil
	self.border = nil
	self.minPercent = nil
	self.maxPercent = nil
	self.percentage = nil
	self.fillMode = nil
	self.shape = nil
end

local function _isVertical(self)
	return self.fillMode == ProgressFill.TTB or self.fillMode == ProgressFill.BTT
end

local function _calculateProgress(self)
	local vertical = _isVertical(self)
	local reversed = not vertical and self.fillMode == ProgressFill.RTL or self.fillMode == ProgressFill.BTT
	local percentRange = self.maxPercent - self.minPercent
	local rangeFraction = (self.percentage - self.minPercent) / percentRange
	local dependingSize = not vertical and self:getWidth() or self:getHeight()
	local fillSize = math.round(rangeFraction * dependingSize)
	-- FIXME: RTL layout starts filled for SOME reason ehhhhh.
	if reversed then
		fillSize = math.round(dependingSize - (rangeFraction * dependingSize))
	end
	return fillSize
end

function ProgressShape:getWidth()
	local more = self.border and self.border.width or 0
	return self.size.x + more
end

function ProgressShape:getHeight()
	return self.size.y
end

function ProgressShape:draw()
	-- TODO: image filling?
	if not self.visible then
		return
	end
	love.graphics.push()
	love.graphics.translate(self.position:unpack())
	love.graphics.rotate(self.rotation)
	if self.border and self.border.width > 0 then
		self:drawBorder()
	end
	self:drawBackground()
	self:drawProgress()
	love.graphics.pop()
end

function ProgressShape:drawProgress()
	love.graphics.setColor(self.colors[2])
	local vertical = _isVertical(self)
	local fillSize = _calculateProgress(self)
	Utils.match(self.shape, {
		[ShapeType.RECTANGLE] = function()
			love.graphics.rectangle(
				"fill",
				0,
				0,
				vertical and self:getWidth() or fillSize,
				not vertical and self:getHeight() or fillSize
			)
		end,
		[ShapeType.CIRCLE] = function()
			-- TODO: polish this and make it better, right now it's FINE, but looks weird.
			love.graphics.circle(
				"fill",
				0,
				0,
				vertical and self:getWidth() or fillSize,
				not vertical and self:getHeight() or fillSize
			)
		end,
	})
	--love.graphics.setColor(Color.WHITE())
end

function ProgressShape:drawBackground()
	love.graphics.setColor(self.colors[1])
	Utils.match(self.shape, {
		[ShapeType.RECTANGLE] = function()
			love.graphics.rectangle("fill", 0, 0, self:getWidth(), self:getHeight())
		end,
		[ShapeType.CIRCLE] = function()
			love.graphics.circle("fill", 0, 0, self:getWidth(), self:getHeight())
		end,
	})
	--love.graphics.setColor(Color.WHITE())
end

function ProgressShape:drawBorder()
	love.graphics.setColor(self.border.color or Color.BLACK())
	love.graphics.setLineWidth(self.border.width)
	Utils.match(self.shape, {
		[ShapeType.RECTANGLE] = function()
			love.graphics.rectangle("line", 0, 0, self:getWidth(), self:getHeight())
		end,
		[ShapeType.CIRCLE] = function()
			love.graphics.circle("line", 0, 0, self:getWidth(), self:getHeight())
		end,
	})
	love.graphics.setLineWidth(1)
end

function ProgressShape:centerPosition(_x_)
	assert(_x_, "Axis value must be either Axis.X, Axis.Y, or Axis.XY")
	local vpw, vph = love.graphics.getDimensions()
	local centerX = _x_ == Axis.X
	local centerY = _x_ == Axis.Y
	if _x_ == Axis.XY then
		centerX = true
		centerY = true
	end
	if centerX then
		self.position.x = (vpw - self:getWidth()) * 0.5
	end
	if centerY then
		self.position.y = (vph - self:getHeight()) * 0.5
	end
end

return ProgressShape
