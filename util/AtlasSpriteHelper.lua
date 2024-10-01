local AtlasSpriteHelper = {}

function AtlasSpriteHelper:getAnimationListSparrow(file)
	local xmldoc, err = require("libraries.xmlparser").parseFile(file)
	if err then
		print("File \""..file.."\" doesn't exist?")
		return {}
	end

	local animations = {}
	--print("animations: "..#animations)
	local curPos = 1
	while curPos < #xmldoc.children[1].children do
		local atlasFrameInfo = xmldoc.children[1].children[curPos].attrs
		if atlasFrameInfo.name ~= nil then
			local animName = string.sub(atlasFrameInfo.name,0,#atlasFrameInfo.name-4)
			if animations[animName] == nil then
				animations[animName] = {frames = {}}
			end
			table.insert(animations[animName].frames, atlasFrameInfo)
		end
		curPos = curPos + 1
	end
	--print("resulting animations "..#animations)
	return animations
end

return AtlasSpriteHelper
