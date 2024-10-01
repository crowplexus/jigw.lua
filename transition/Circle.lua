Transition = Object:extend()
function Transition:__tostring() return "CircleTransition" end

local transIn = true --- @type boolean
local finished = true --- @type boolean
local started = false --- @type boolean

local speed = 30 --- @type number
local circS = 0 --- @type number
local canvasSize --- @class Vector2

function Transition:reset()
	started = false
	finished = false
	transIn = true
	local w, h = love.graphics.getDimensions()
	canvasSize = Vector2(w,h)
end

function Transition:draw()
	if finished then return end
	local circX = (canvasSize.x) * 0.5
  local circY = (canvasSize.y) * 0.5
	love.graphics.setColor(Color.rgb(0,0,0))
  love.graphics.circle("fill",circX,circY,circS,circS)
  love.graphics.setColor(Color.WHITE)
  if transIn then self:inwards() else self:outwards() end
  if circS < 0 then finished = true end
end

function Transition:inwards(force)
  if circS >= 900 then transIn = false end
	if force == true and not started then
		transIn = true
		started = true
		circS = 0
	end
  circS = circS + speed
end

function Transition:outwards(force)
	if force == true and not started then
		transIn = false
		started = true
		circS = 900
	end
  circS = circS - speed
end

return Transition
