--- A subviewport with scrolling.
--- @class jigw.Camera
local Camera = Classic:extend("Camera")

function Camera:construct(x, y)
	local w, h = love.graphics.getDimensions()
	self._subCanvas = love.graphics.newCanvas(w, h) --- @class love.Canvas
	self.position = Vector2(x, y)               --- @class Vector2
	self.color = { 0, 0, 0, 0 }                 --- @class Color
	self.rotation = 0                           --- @type number

	-- I kinda wanna do like layers with properties
	-- something like idk:
	-- self.layers = {}
	-- and then you'd
	-- self:addLayer(type:LayerType.STATIC,offset:Vector2())
	-- and then objects point to a layer ID or something to use the correct one
	-- could be useful for HUD since static layers wouldn't move.
	-- layers themselves can be hidden and have a colour of their own and stuff
	--
	-- ngl kinda based it off of how the NES handles it lol.
end

function Camera:update(dt) end

function Camera:draw()
	love.graphics.push("all")
	love.graphics.setCanvas(self._subCanvas)
	love.graphics.clear(self.color)
	love.graphics.setCanvas()
	love.graphics.draw(self._subCanvas, self.position.x, self.position.y, self.rotation)
	love.graphics.pop()
end

function Camera:addLayer(type, offset) end

function Camera:removeLayer(type, offset) end

return Camera
