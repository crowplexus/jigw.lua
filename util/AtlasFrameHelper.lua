local AtlasFrameHelper = {}

function AtlasFrameHelper.getAnimationListSparrow(file)
	local xmldoc, err = require("jigw.lib.xmlparser").parseFile(file)
	if err then
		print('File "' .. file .. "\" doesn't exist?")
		return {}
	end

	local animations = {}
	--print("animations: "..#animations)
	local curPos = 1
	while curPos < #xmldoc.children[1].children do
		local atlasFrameInfo = xmldoc.children[1].children[curPos].attrs
		if atlasFrameInfo.name ~= nil then
			local animName = string.sub(atlasFrameInfo.name, 0, #atlasFrameInfo.name - 4)
			if animations[animName] == nil then
				animations[animName] = { frames = {} }
			end
			table.insert(animations[animName].frames, atlasFrameInfo)
		end
		curPos = curPos + 1
	end
	--print("resulting animations "..#animations)
	return animations
end

function AtlasFrameHelper.buildSparrowQuad(animationList, texture)
	if texture == nil then
		assert(
			"Attempt to build an SparrowAtlas Quad without a texture, did you forget to set a texture to an AnimatedSprite?"
		)
		return
	end
	local frames = {}
	for i = 1, #animationList do
		local cfg = animationList[i]
		local trimmed = cfg.frameX

		--		TODO: test and implement these				--
		local rotated = cfg.rotated == "true" or false
		local flippedX = cfg.flipX == "true" or false
		local flippedY = cfg.flipY == "true" or false

		local frameRect = { x = cfg.x, y = cfg.y, width = cfg.width, height = cfg.height }
		if trimmed then
			local frameMargin = {
				x = cfg.frameX,
				y = cfg.frameY,
				width = cfg.frameWidth - frameRect.width,
				height = cfg.frameHeight - frameRect.height,
			}
			if frameMargin.width < math.abs(frameMargin.x) then
				frameMargin.width = math.abs(frameMargin.x)
			end
			if frameMargin.height < math.abs(frameMargin.y) then
				frameMargin.height = math.abs(frameMargin.y)
			end
			Rect2.combine(frameRect, frameMargin)
		end
		table.insert(frames, {
			quad = love.graphics.newQuad(
				frameRect.x,
				frameRect.y,
				frameRect.width,
				frameRect.height,
				texture:getDimensions()
			),
			offset = not trimmed and { x = 0, y = 0 } or { x = cfg.frameX, y = cfg.frameY },
			scale = { x = flipX and -1 or 1, y = flipY and -1 or 1 },
			rotation = rotated and -90 or 0,
		})
		--Utils.tablePrint(frames)
	end
	return frames
end

return AtlasFrameHelper
