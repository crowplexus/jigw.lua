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
	--print(animations)
	return animations
end

function AtlasFrameHelper.buildSparrowQuad(attributes, texture)
	local frames = {}
	if texture == nil then
		assert(
			"Attempt to build an SparrowAtlas Quad without a texture, did you forget to set a texture to an AnimatedSprite?"
		)
		return frames
	end
	if #attributes == 0 then
		assert("Attempt to build an SparrowAtlas Quad without any attributes.")
		return frames
	end
	local i = 1
	while i <= #attributes do
		local cfg = attributes[i]
		print(cfg)
		local trimmed = math.abs(cfg.frameX or 0) ~= 0
		local rotated = cfg.rotated == "true" or false
		local flipX = cfg.flipX == "true" or false
		local flipY = cfg.flipY == "true" or false
		local frame = {
			source = { x = cfg.x or 0, y = cfg.y or 0, width = cfg.width or 1, height = cfg.height or 1 },
			offset = { x = cfg.frameX or 0, y = cfg.frameY or 0, width = cfg.frameWidth or 0, height = cfg.frameHeight or 0 },
			rotation = rotated and math.rad(-90) or 0,
			scale = { x = 1, y = 1 },
		}
		local sourceSize = { x = (trimmed and frame.offset or frame.source).width, y = (trimmed and frame.offset or frame.source)
		.height }

		if not trimmed and rotated then
			sourceSize = { x = (trimmed and frame.offset or frame.source).height, y = (trimmed and frame.offset or frame.source)
			.width }
		end
		-- flip frame if necessary
		if flipX then frame.scale.x = frame.scale.x * -1 end
		if flipY then frame.scale.y = frame.scale.y * -1 end
		table.insert(frames, {
			quad = love.graphics.newQuad(
				frame.source.x,
				frame.source.y,
				frame.source.width,
				frame.source.height,
				texture:getDimensions()
			),
			sourceSize = sourceSize,
			rotation = frame.rotation,
			offset = frame.offset,
			scale = frame.scale,
		})
		i = i + 1
	end
	--print(frames)
	return frames
end

return AtlasFrameHelper
