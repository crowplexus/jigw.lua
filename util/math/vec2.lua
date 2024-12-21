--- @class Vec2
local Vec2 = Class("Vec2")

function Vec2:init(x, y)
    self.x = x or 0
    self.y = y or 0
end

function Vec2:round() return self:new(math.floor(self.x + 0.5), math.floor(self.y + 0.5)) end

function Vec2:floor() return self:new(math.floor(self.x), math.floor(self.y)) end

function Vec2:ceil() return self:new(math.ceil(self.x), math.ceil(self.y)) end

function Vec2:unpack() return self.x or 0, self.y or 0 end

function Vec2:dispose()
    for k, _ in pairs(self) do
        self[k] = nil
    end
    self = nil
end

return function(x, y) return Vec2:new(x, y) end
