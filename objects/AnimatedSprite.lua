--- @enum AnimationRepeat
local AnimationRepeat = {
	NEVER = 0,
	ON_END = 1,
	TO_FRAME = 2,
}

local function buildAnimatedSprite(sel)
	sel.position = Vector2(0,0) -- X, Y
	sel.offset = Vector2(0, 0)
	sel.scale = Vector2(1,1)
	sel.color = Color.WHITE()
	sel.centered = true
	sel.visible = true
	sel.rotation = 0
	sel.alpha = 1.0
	sel.animations = {}
	sel.animation = {
		name = "default",
		progress = 0
	}
  sel.transform = love.math.newTransform()
	sel.currentAnimation = nil
  sel.currentFrame = nil;
	sel.animationProgress = 0
	sel.texture = nil
	return sel
end

local function buildAnimation()
	return {
		name = "default",
		texture = nil, --- @class love.graphics.Image
		frames = {}, --- @class love.graphics.Quad
		frameRate = 30, --- @type number
		offset = Vector2(0,0),
		repeatMode = AnimationRepeat.NEVER, --- @type number|AnimationRepeat
		--- is only valid if `repeatMode` gets set to 2|TO_FRAME
		--- @type number
		repeatFrame = nil,
		length = 0, --- @type number
	}
end

local AnimatedSprite = Object:extend() --- @class AnimatedSprite
function AnimatedSprite:__tostring() return "AnimatedSprite" end

function AnimatedSprite:new(x,y,tex)
	buildAnimatedSprite(self)
	self.position.x = x
	self.position.y = y
	if tex then self.texture = tex end
end

function AnimatedSprite:update(dt)
	if self.currentAnimation ~= nil then
		local curAnim = self.currentAnimation
		local animationEnd = curAnim.length
		if self.animationProgress < animationEnd then
			self.animationProgress = self.animationProgress + dt / (curAnim.frameRate * 0.0018)
		else
			--- repeats the animation if we even can lol
			if curAnim.repeatMode == AnimationRepeat.NEVER then
				self.animationProgress = self.animationProgress - animationEnd
				return
			end
			local returnToFrame = self.animationProgress - animationEnd
			if curAnim.repeatMode == AnimationRepeat.TO_FRAME and curAnim.repeatFrame then
				returnToFrame = curAnim.repeatFrame
			end
			self.animationProgress = returnToFrame
		end
		self.currentFrame = self.currentAnimation.frames[self:getProgress()]
	end
end

function AnimatedSprite:draw()
	if not self.texture or not self.visible then
		return
	end
	love.graphics.push("all")
	love.graphics.setColor(self.color)
	if self.currentFrame == nil then
		love.graphics.draw(self.texture,self.position.x,self.position.y,self.rotation,self.scale.x,self.scale.y)
	else
		local currentFrame = self.currentFrame;
		local _, _, frW, frH = currentFrame.quad:getViewport()

		self.transform:reset();
		self.transform:translate(self.position:unpack())
		self.transform:translate(self.offset.x, self.offset.y);
		self.transform:rotate(self.rotation + currentFrame.rotation);
		if(self.centered)then
			self.transform:translate(-frW * 0.5, -frH * 0.5)
		end
		love.graphics.draw(self.currentAnimation.tex,currentFrame.quad,self.transform)
	end
	--love.graphics.setColor(Color.WHITE)
	love.graphics.pop()
end

function AnimatedSprite:dispose()
	for idx,anim in ipairs(self.animations) do
		for qd,prms in self.animations.quads do
			if prms.quad.release then prms.quad:release() end
			prms = nil
		end
		anim = nil
	end
	self.texture:release()
	buildAnimatedSprite(self)
end

function AnimatedSprite:centerPosition(_x_)
	assert(_x_, "Axis value must be either Axis.X, Axis.Y, or Axis.XY")
	local vpw, vph = love.graphics.getDimensions()
	local centerX = _x_ == Axis.X
	local centerY = _x_ == Axis.Y
	if(_x_ == Axis.XY)then
		centerX = true
		centerY = true
	end
	if centerX then self.position.x = vpw* 0.5 end
	if centerY then self.position.y = vph* 0.5 end
	self.centered = centerX == true or centerY == true
end

function AnimatedSprite:getProgress()
  local cur = self.currentAnimation
  local progress = math.floor(self.animationProgress / cur.length * #cur.frames) + 1
	if progress < 1 or progress > cur.length then progress = 1 end
  return progress;
end

function AnimatedSprite:loadAtlas(path, animTable)
	self.texture = love.graphics.newImage(path..".png")
	if type(animTable) == "table" then
		local atlasHelper = require("jigw.util.AtlasFrameHelper")
		local animationList = atlasHelper.getAnimationListSparrow(path..".xml")
		for i,v in ipairs(animTable) do
			local x = animationList[v[2]].frames
			local quad = atlasHelper.buildSparrowQuad(x, self.texture)
			self:addAnimationFromAtlasQuad(v[1],quad,v[3])
		end
	end
	return animationList
end

-- function AnimatedSprite:addAnimation(name,x,y,width,height,fps,duration,tex)
-- 	tex = tex or self.texture
-- 	if tex == nil then
-- 		print("Cannot add animation to a texture-less AnimatedSprite.")
-- 		return nil
-- 	end
-- 	local anim = buildAnimation()
-- 	anim.tex = tex
-- 	anim.name = name or "default"
-- 	anim.frameRate = fps or 30
-- 	for _y = 0, tex:getHeight() - height, height do
-- 		for _x = 0, tex:getWidth() - width, width do
-- 			table.insert(anim.frames, love.graphics.newQuad(_x,_y,width,height,tex:getDimensions()))
-- 		end
-- 	end
-- 	anim.length = duration or 1
-- 	self.animations[name] = anim
-- 	return anim
-- end

function AnimatedSprite:addAnimationFromAtlasQuad(name,quads,fps,duration)
	local anim = buildAnimation()
	anim.tex = self.texture
	if anim.tex == nil then
		print("Cannot add animation to a texture-less AnimatedSprite.")
		return nil
	end
	anim.name = name or "default"
	anim.frameRate = fps or 30
	for i=1,#quads do table.insert(anim.frames,quads[i]) end
	anim.length = duration or #anim.frames or 1
	self.animations[name] = anim
	return anim
end

function AnimatedSprite:addOffsetToAnimation(name,x,y)
	local anim = self.animations[name]
	if anim == nil then
		print("Cannot add offset to a animation that doesn't exist.")
		return
	end
	anim.offset = Vector2(x,y)
	self.animations[name] = anim
	return anim
end

function AnimatedSprite:playAnimation(name, forced)
	if not forced or type(forced) ~= "boolean" then forced = false end
	if self.animations and self.animations[name] then
		self.currentAnimation = self.animations[name];
		if forced then self.animationProgress = 0 end
	end
end


return AnimatedSprite
