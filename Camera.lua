local Camera = Object:extend() --- @class jigw.Camera

function Camera:new(x,y)
	local sz = Vector2(love.graphics.getWidth(),love.graphics.getHeight())
  self._subCanvas = love.graphics.newCanvas(sz.x, sz.y) --- @class love.Canvas
  self.position = Vector2(x,y) --- @class Vector2
	self.color = Color.WHITE --- @class Color
  self.rotation = 0 --- @type number

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

function Camera:update(dt)
end

function Camera:draw()
end

function Camera:addLayer(type,offset)
end
function Camera:removeLayer(type,offset)
end

return Camera
