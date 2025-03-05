--- @class Vec3
local Vec3 = Class("Vec3")

function Vec3:__call(x, y, z) return self:new(x, y, z) end

--- Creates a new Vector with 3 coordinates.
--- @param x? number  The x position.
--- @param y? number  The y position.
--- @param z? number  The z position.
function Vec3:init(x, y, z)
	self.x = x or 0
	self.y = y
	self.z = z or 0
end

--- Rounds the values of the vector, then returns it.
--- @return Vec3
function Vec3:round() return self:new(math.floor(self.x + 0.5), math.floor(self.y + 0.5), math.floor(self.z + 0.5)) end

--- Floors the values of the vector, then returns it.
--- @return Vec3
function Vec3:floor() return self:new(math.floor(self.x), math.floor(self.y), math.floor(self.z)) end

--- Ceils the values of the vector, then returns it.
--- @return Vec3
function Vec3:ceil() return self:new(math.ceil(self.x), math.ceil(self.y), math.ceil(self.z)) end

--- Returns the values of the vector one by one.
--- @return number, number, number
function Vec3:unpack() return self.x, self.y, self.z end

--- Disposes of the vector and clears its values from memory.
function Vec3:dispose()
	for k, _ in pairs(self) do
		self[k] = nil
	end
end

--- @see Vec3.new
return function(x, y, z) return Vec3:new(x, y, z) end
