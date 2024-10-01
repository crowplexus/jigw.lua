local Vector2 = Object:extend()
function Vector2:__tostring()
	return "(Vector2, X "..self.x.." Y "..self.y..")"
end

function Vector2:new(x,y)
	self.x = (x and type(x) == "number") and x or 0
	self.y = (y and type(y) == "number") and y or 0
end

function Vector2:round()
	return Vector2:new(math.round(self.x),math.round(self.y))
end

function Vector2:sortByY(o,a,b)
	if not a or not b then return false end
	if not Vector2.is(a) or not Vector2.is(b) then return false end
	return o > 0 and a.y < b.y or a.y > b.y
end

function Vector2:unpack()
    return self.x, self.y
end

return Vector2
