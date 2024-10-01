local Rect2 = Object:extend()
function Rect2:__tostring()
	return "(Rect2, X "..self.x.." Y "..self.y.." Width "..self.width.." Height "..self.height..")"
end

function Rect2:new(x,y,w,h)
	self.x = x or 0
	self.y = y or 0
	self.width = w or 0
	self.height = h or 0
end

function Rect2:round()
	return Rect2:new(
		math.floor(self.x+0.5),math.floor(self.y+0.5),
		math.floor(self.width+0.5),math.floor(self.height+0.5)
	)
end

function Rect2:combine(with)
	self.x = self.x + with.x
	self.y = self.y + with.y
	self.width = self.width + with.width
	self.height = self.height + with.height
	return self
end

return Rect2
