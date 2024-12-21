--- @class Rect3
local Rect3 = Class("Rect3")

function Rect3:__call(x, y, z, w, h, d)
    return self:new(x, y, z, w, h, d)
end

function Rect3:init(x, y, z, w, h, d)
    self.x = x or 0
    self.y = y or 0
    self.z = z or 0
    self.w = w or 0
    self.h = h or 0
    self.d = d or 0
end

function Rect3:round()
    return self:new(math.floor(self.x + 0.5), math.floor(self.y + 0.5),
        math.floor(self.z + 0.5), math.floor(self.w + 0.5), math.floor(self.h + 0.5), math.floor(self.d + 0.5))
end

function Rect3:floor()
    return self:new(math.floor(self.x), math.floor(self.y), math.floor(self.z),
        math.floor(self.w), math.floor(self.h), math.floor(self.d))
end

function Rect3:ceil()
    return self:new(math.ceil(self.x), math.ceil(self.y), math.ceil(self.z), math.ceil(self.w),
        math.ceil(self.h), math.ceil(self.d))
end

function Rect3:unpack() return self.x or 0, self.y or 0, self.z or 0, self.w or 0, self.h or 0, self.d or 0 end

function Rect3:dispose()
    for k, _ in pairs(self) do
        self[k] = nil
    end
    self = nil
end

return function(x, y, z, w, h, d) return Rect3:new(x, y, z, w, h, d) end
