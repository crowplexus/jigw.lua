-- TODO: maybe move worldCenter functions from objects to here?

--- @class Vec2
local Vec2 = Class("Vec2")

function Vec2:__call(x, y) return self:new(x, y) end

--- Creates a new Vector with 2 coordinates.
--- @param x? number  The x position.
--- @param y? number  The y position.
function Vec2:init(x, y)
	self.x = x or 0
	self.y = y or 0
	return self
end

--- Rounds the values of the vector, then returns it.
--- @return Vec2
function Vec2:round() return self:new(math.floor(self.x + 0.5), math.floor(self.y + 0.5)) end

--- Floors the values of the vector, then returns it.
--- @return Vec2
function Vec2:floor() return self:new(math.floor(self.x), math.floor(self.y)) end

--- Ceils the values of the vector, then returns it.
--- @return Vec2
function Vec2:ceil() return self:new(math.ceil(self.x), math.ceil(self.y)) end

--- Returns the values of the vector one by one.
--- @return number, number
function Vec2:unpack() return self.x or 0, self.y end

--- Disposes of the vector and clears its values from memory.
function Vec2:dispose()
	for k, _ in pairs(self) do
		self[k] = nil
	end
end

--- @see Vec2.new
return function(x, y) return Vec2:new(x, y) end
