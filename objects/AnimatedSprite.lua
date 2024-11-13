local AnimatedSprite = Classic:extend("AnimatedSprite") --- @class AnimatedSprite

local function buildAnimation()
	-- TODO: loopable animations + loop points
	return {
		name = "nil",
		loop = true, --- @type boolean|number
		texture = nil, --- @class love.graphics.Image
		frames = {}, --- @class love.graphics.Quad
		frameRate = 30, --- @type number
		offset = { x = 0, y = 0 },
		length = 0, --- @type number
	}
end

function AnimatedSprite:construct(x, y, tex)
	self.position = Vector2(x, y) -- X, Y
	self.offset = Vector2(0, 0)
	self.scale = Vector2(1, 1)
	self.color = Color.WHITE()
	self.centered = true
	self.visible = true
	self.rotation = 0
	self.alpha = 1.0
	self.animations = {}
	self.animation = {
		name = "default",
		progress = 0,
	}
	self.transform = love.math.newTransform()
	self.currentAnimation = nil
	self.currentFrame = nil
	self.texture = nil
	if tex then
		self.texture = tex
	end
	return self
end

function AnimatedSprite:update(dt)
	if self.currentAnimation == nil then
		return
	end
	local curFrameProg = self:getProgress() or 0.0
	local curFrameDur = self.currentAnimation.length or 1.0
	local curFrameRate = self.currentAnimation.frameRate or 30
	self.animation.progress = self.animation.progress + curFrameRate * dt
	if self.animation.progress > curFrameDur then
		--if self.animation.loop then
		local zero = self.animation.progress - curFrameDur
		self.animation.progress = self.animation.loop or zero
		--end
	end
	self.currentFrame = self.currentAnimation.frames[curFrameProg]
end

function AnimatedSprite:draw()
	if not self.texture or not self.visible then
		return
	end
	love.graphics.push("all")
	love.graphics.setColor(self.color)
	if self.currentFrame == nil then
		love.graphics.draw(self.texture, self.position.x, self.position.y, self.rotation, self.scale.x, self.scale.y)
	else
		-- TODO: rewrite all of this
		local currentFrame = self.currentFrame
		local currentAnimation = self.currentAnimation
		local _, frY, frW, frH = currentFrame.quad:getViewport()

		self.transform:reset()
		-- position and offset frame
		self.transform:translate(self.position:unpack())
		self.transform:translate(self.offset.x + currentAnimation.offset.x, self.offset.y + currentAnimation.offset.y)
		-- properly rotate the frame
		self.transform:rotate(self.rotation + currentFrame.rotation)
		-- offset that bitch
		self.transform:translate(-currentFrame.offset.x / 2, -currentFrame.offset.y / 2)
		-- center whole sprite to screen
		if self.centered then
			self.transform:translate(-frW * 0.5, -frH * 0.5)
		end
		love.graphics.draw(self.currentAnimation.tex, currentFrame.quad, self.transform)
	end
	--love.graphics.setColor(Color.WHITE)
	love.graphics.pop()
end

function AnimatedSprite:dispose()
	for i = 1, #self.animations do
		for j = 1, #self.animations[i].frames do
			if self.animations[i].frames[j].quad.release then
				self.animations[i].frames[j].quad:release()
			end
		end
		self.animations[i] = nil
	end
	if self.texture ~= nil then
		if self.texture.release then
			self.texture:release()
		end
		self.texture = nil
	end
	self.position = nil
	self.offset = nil
	self.scale = nil
	self.color = nil
	self.centered = nil
	self.visible = nil
	self.rotation = nil
	self.alpha = nil
	self.animations = nil
	self.animation = nil
	self.transform = nil
	self.currentAnimation = nil
	self.currentFrame = nil
	self.texture = nil
end

function AnimatedSprite:centerPosition(_x_)
	assert(_x_, "Axis value must be either Axis.X, Axis.Y, or Axis.XY")
	local vpw, vph = love.graphics.getDimensions()
	local centerX = _x_ == Axis.X
	local centerY = _x_ == Axis.Y
	if _x_ == Axis.XY then
		centerX = true
		centerY = true
	end
	if centerX then
		self.position.x = vpw * 0.5
	end
	if centerY then
		self.position.y = vph * 0.5
	end
	self.centered = centerX == true or centerY == true
end

function AnimatedSprite:getProgress()
	local cur = self.currentAnimation
	local progress = math.floor(self.animation.progress / cur.length * #cur.frames) + 1
	if progress < 1 or progress > cur.length then
		progress = 1
	end
	return progress
end

function AnimatedSprite:getCurrentAnimation()
	return self.currentAnimation or buildAnimation()
end

function AnimatedSprite:getCurrentAnimationName()
	return self.currentAnimation.name or "nil"
end

function AnimatedSprite:hasAnimation(name)
	return self.animations[name] and self.animations[name].name
end

--- Loads a sparrow atlas (adobe animate) with animations
---
--- Animation table example:
--- ```lua
--- -- in order: name, name in file, fps, loop, x, y
--- { "default", "default", 30, false, 0, 0 }
--- ```
--- @param path string The path to the atlas.
--- @param animTable table A table of animations to load.
function AnimatedSprite:loadAtlas(path, animTable)
	local atlasHelper = require("jigw.util.AtlasFrameHelper")
	if self.texture then self.texture:release() end
	self.texture = love.graphics.newImage(path .. ".png")
	local animationList = atlasHelper.getSparrowAtlas(path .. ".xml")
	if type(animTable) == "table" then
		local i = 1
		while i <= #animTable do
			local v = animTable[i]
			local animName = v[1]
			local quad = atlasHelper.buildSparrowQuad(animationList[v[2]].frames, self.texture)
			self:addAnimationFromAtlasQuad(animName, quad, v[3])
			self:addOffsetToAnimation(animName, v[5] or 0, v[6] or 0)
			self:addAnimationLoopPoint(animName, v[4])
			i = i + 1
		end
	end
	return self.texture, animationList
end

function AnimatedSprite:addAnimationFromAtlasQuad(name, quads, fps, duration)
	local anim = buildAnimation()
	anim.tex = self.texture
	if anim.tex == nil then
		print("Cannot add animation to a texture-less AnimatedSprite.")
		return nil
	end
	anim.name = name or "default"
	anim.frameRate = fps or 30
	for i = 1, #quads do
		table.insert(anim.frames, quads[i])
	end
	anim.length = duration or #anim.frames or 1
	self.animations[name] = anim
	return anim
end

function AnimatedSprite:addOffsetToAnimation(name, x, y)
	local anim = self.animations[name]
	if anim == nil then
		print("Cannot add offset to a animation that doesn't exist.")
		return
	end
	anim.offset = { x = x or 0, y = y or 0 }
	self.animations[name] = anim
	return anim
end

function AnimatedSprite:addAnimationLoopPoint(name, point)
	local anim = self.animations[name]
	if anim == nil then
		print("Cannot add offset to a animation that doesn't exist.")
		return
	end
	anim.loop = point or true
	self.animations[name] = anim
	return anim
end

function AnimatedSprite:playAnimation(name, forced)
	if not forced or type(forced) ~= "boolean" then
		forced = false
	end
	if self.animations and self.animations[name] then
		if forced then
			self.animation.progress = 0
		end
		self.currentAnimation = self.animations[name]
	end
end

function AnimatedSprite:get_alpha()
	return self.color[4]
end

function AnimatedSprite:set_alpha(vl)
	if self and self.color then self.color[4] = vl end
end

return AnimatedSprite
