--- @class FrameCollection
local FrameCollection = {}

function FrameCollection:fromDataList(image, list)
	local anim = {
		frames = {},
		image = image or nil,
	}

	list = list or {}
	if #list == 0 then
		print("list is empty, returning empty animation")
		return anim
	end

	local i = 1
	while i <= #list do
		local data = list[i]
		if not data.x or not data.y or not data.width or not data.height then
			return
		end
		--local rot = math.rad(data.angle or 90) or 0
		anim.frames[#anim.frames + 1] = {
			quad = love.graphics.newQuad(data.x, data.y, data.width, data.height, image:getDimensions()),
			offset = data.offset or { x = 0, y = 0 },
			scale = data.scale or { x = 1, y = 1 },
			rotation = data.angle or 0,
		}
	end

	return anim
end

--- @see https://love2d.org/wiki/Tutorial:Animation
function FrameCollection:fromImage(image, width, height)
	local anim = {
		frames = {},
		image = image or nil,
		offset = { x = 0, y = 0 },
	}
	for y = 0, image:getHeight() - height do
		for x = 0, image:getWidth() - width do
			anim.frames[#anim.frames + 1] = {
				quad = love.graphics.newQuad(x, y, width, height, image:getDimensions()),
				offset = { x = 0, y = 0 },
				scale = { x = 1, y = 1 },
				rotation = 0,
			}
		end
	end
	return anim
end

return FrameCollection
