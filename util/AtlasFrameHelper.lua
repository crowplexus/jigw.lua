local AtlasFrameHelper = {}

function AtlasFrameHelper.getSparrowAtlas(file)
	local xmldoc, err = require("jigw.lib.xmlparser").parseFile(file)
	if err then
		print('File "' .. file .. "\" doesn't exist?")
		return {}
	end

	local candidate = 1
	local function getElement()
		--return xmldoc.children[candidate].children
		local element = xmldoc.children[candidate]
		if element.children ~= nil then
			element = xmldoc.children[candidate].children
		else
			while xmldoc.children[candidate].children == nil do
				element = xmldoc.children[candidate]
				candidate = candidate + 1
			end
			element = xmldoc.children[candidate].children
		end
		return element
	end

	local doctable = getElement()
	local animations = {}
	local curPos = 1

	while curPos <= #doctable do
		if doctable[curPos].tag == "SubTexture" then
			local attrs = doctable[curPos].attrs
			local animName = string.sub(attrs.name, 0, #attrs.name - 4)
			if animations[animName] == nil then
				animations[animName] = { frames = {} }
			end
			table.insert(animations[animName].frames, attrs)
		end
		curPos = curPos + 1
	end
	--Utils.tablePrint(animations)
	return animations
end

function AtlasFrameHelper.buildSparrowQuad(attributes, texture)
	local frames = {}
	--if texture == nil then
	--	assert(
	--		"Attempt to build an SparrowAtlas Quad without a texture, did you forget to set a texture to an AnimatedSprite?"
	--	)
	--	return frames
	--end
	--if #attributes == 0 then
	--	assert("Attempt to build an SparrowAtlas Quad without any attributes.")
	--	return frames
	--end
	local i = 1
	while i <= #attributes do
		local cfg = attributes[i]
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
			frameRect = Rect2.combine(frameRect, frameMargin)
		end
		local newFrame = {
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
		}
		table.insert(frames, newFrame)
		i = i + 1
	end
	--Utils.tablePrint(frames)
	return frames
end

return AtlasFrameHelper
