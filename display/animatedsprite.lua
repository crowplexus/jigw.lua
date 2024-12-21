--- @class AnimatedSprite
local AnimatedSprite = Class()

local framedt = 0
local lastanim = nil
local transform = love.math.newTransform()

--- Creates an AnimatedSprite.
--- @param x? number     X position.
--- @param y? number     Y position.
function AnimatedSprite:init(x, y)
    self.visible = true            --- @type boolean
    self.texture = nil             --- @type love.Image
    self.position = Vec2(x, y)     --- @type Vec2
    self.scale = Vec2(1, 1)        --- @type Vec2
    self.color = { 1, 1, 1, 1 }    --- @type table<number>
    self.angle = 0                 --- @type number
    self.centered = 0x00           --- @type number
    self.animation = {
        current = nil,             --- @type table
        playing = false,           --- @type boolean
        offset = { x = 0, y = 0 }, --- @type table[number,number]
        speed = 1.0,               --- @type number
        frame = nil,               --- @type table
        list = {},                 --- @type table
    }                              --- @type table
    return self
end

function AnimatedSprite:update(dt)
    if self.animation.playing then
        local nextframe = framedt + dt * self.animation.speed * self.animation.current.fps
        if self.animation.current.loop then
            while nextframe < 0 or nextframe > self.animation.current.length do
                if nextframe <= 0 then
                    nextframe = nextframe + self.animation.current.length
                else
                    nextframe = nextframe - self.animation.current.length
                end
                -- self.animation.playing = false
            end
        else
            if nextframe <= 0 then
                nextframe = 0
                self.animation.finished = true
            elseif nextframe > #self.animation.current.frames then
                nextframe = #self.animation.current.frames
                self.animation.finished = true
                -- call finish callback here.
            end
        end
        framedt = nextframe
        self.animation.frame = self.animation.current.frames[math.ceil(math.max(1, framedt))]
    end
end

function AnimatedSprite:draw()
    if self.texture and self.visible then
        love.graphics.push("all")
        if self.color then love.graphics.setColor(self.color) end
        transform:reset()
        transform:translate(self.position.x or 0, self.position.y or 0)
        local frame = self.animation.frame
        if self.animation.playing and frame then
            -- offset current frame
            if frame.offset then
                transform:translate(-frame.offset.x, -frame.offset.y)
            end
            -- rotate current frame
            transform:rotate(self.angle + frame.angle)
            -- offset the animation
            transform:translate(self.animation.offset.x or 0, self.animation.offset.y or 0)
            if self.centered ~= 0x00 then -- this should probably be an enum
                local _, _, vpW, vpH = self.animation.frame.quad:getViewport()
                if self.centered == 0x01 then
                    transform:translate(-vpW * 0.5, 0)
                elseif self.centered == 0x02 then
                    transform:translate(0, -vpH * 0.5)
                elseif self.centered == 0x03 then
                    transform:translate(-vpW * 0.5, -vpH * 0.5)
                end
            end
            -- done, draw the animation
            love.graphics.draw(self.texture, self.animation.frame.quad, transform)
        else
            transform:scale(self.scale.x, self.scale.y)
            transform:rotate(self.angle)
            love.graphics.draw(self.texture, transform)
        end
        if self.color then love.graphics.setColor(1, 1, 1, 1) end
        love.graphics.pop()
    end
end

function AnimatedSprite:set_texture(nvl)
    if not nvl then return end
    if self.texture ~= nil then
        self.texture:release()
        self.texture = nil
    end
    self.texture = nvl
end

function AnimatedSprite:addAnimation(name, frames, loop, fps, length, texture)
    local anim = {
        name = name or "default",          --- @type string
        loop = loop or false,              --- @type boolean
        frames = frames or {},             --- @type table
        offset = { x = 0, y = 0 },         --- @type table
        fps = fps or 30,                   --- @type number
        length = length or #frames or 0.0, --- @type number
        texture = texture or self.texture, --- @type love.Image
    }
    self.animation.list[name] = anim
end

function AnimatedSprite:addAnimationOffset(name, x, y)
    local anim = self.animation.list[name]
    self.animation.list[name].offset = { x or anim.offset.x or 0, y or anim.offset.y or 0 }
end

function AnimatedSprite:playAnimation(name, forced, speed)
    local anim = self.animation.list[name]
    if anim ~= nil then
        forced = forced or false
        local newanim = lastanim ~= anim.name
        self.animation.current = anim
        self.animation.speed = speed or 1.0
        if newanim or forced then self.animation.frame = 0 end
        self.animation.frame = self.animation.current.frames[1]
        self.animation.offset = self.animation.current.offset
        lastanim = self.animation.current
        self.animation.playing = true
    end
end

function AnimatedSprite:stopAnimation()
    self.animation.playing = false
    self.animation.frame = 0
end

function AnimatedSprite:worldCenter(type)
    local x, y = love.graphics.getDimensions()
    if type == 0x01 or type == 0x03 then self.position.x = x * 0.5 end
    if type == 0x02 or type == 0x03 then self.position.y = y * 0.5 end
    self.centered = type
end

function AnimatedSprite:set_texture(nvl)
    if not nvl then return end
    if self.texture ~= nil then
        self.texture:release()
        self.texture = nil
    end
    self.texture = nvl
end

return AnimatedSprite
