--- @class Vec3
local Vec3 = Class("Vec3")

function Vec3:__call(x, y, z)
    return self:new(x, y, z)
end

function Vec3:init(x, y, z)
    self.x = x or 0
    self.y = y or 0
    self.z = z or 0
end

function Vec3:round() return self:new(math.floor(self.x + 0.5), math.floor(self.y + 0.5), math.floor(self.z + 0.5)) end

function Vec3:floor() return self:new(math.floor(self.x), math.floor(self.y), math.floor(self.z)) end

function Vec3:ceil() return self:new(math.ceil(self.x), math.ceil(self.y), math.ceil(self.z)) end

function Vec3:unpack() return self.x, self.y, self.z end

function Vec3:dispose()
    for k, _ in pairs(self) do
        self[k] = nil
    end
    self = nil
end

return function(x, y, z) return Vec3:new(x, y, z) end
