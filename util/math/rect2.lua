--- @class Rect2
local Rect2 = Class("Rect2")

function Rect2:__call(x, y, w, h)
    return self:new(x, y, w, h)
end

function Rect2:init(x, y, z, w, h)
    self.x = x or 0
    self.y = y or 0
    self.z = z or 0
    self.w = w or 0
    self.h = h or 0
end

function Rect2:round()
    return self:new(math.floor(self.x + 0.5), math.floor(self.y + 0.5), math.floor(self.z + 0.5),
        math.floor(self.w + 0.5), math.floor(self.h + 0.5))
end

function Rect2:floor()
    return self:new(math.floor(self.x), math.floor(self.y), math.floor(self.z), math.floor(self.w),
        math.floor(self.h))
end

function Rect2:ceil()
    return self:new(math.ceil(self.x), math.ceil(self.y), math.ceil(self.z), math.ceil(self.w), math.ceil(self.h))
end

function Rect2:unpack() return self.x or 0, self.y or 0, self.z or 0, self.w or 0, self.h or 0 end

function Rect2:dispose()
    for k, _ in pairs(self) do
        self[k] = nil
    end
    self = nil
end

return function(x, y, z, w, h) return Rect2:new(x, y, z, w, h) end
