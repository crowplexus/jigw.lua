local Rect3 = Object:extend()
function Rect3:__tostring()
	return "(Rect3, X "..self.x.." Y "..self.y.." Z "..self.z.." Width "..self.width.." Height "..self.height.." Depth "..self.depth..")"
end

function Rect3:new(x,y,z,w,h,d)
	self.x = x or 0
	self.y = y or 0
	self.z = z or 0
	self.width = w or 0
	self.height = h or 0
	self.depth = d or 0
end

function Rect3:round()
	return Rect3:new(
		math.floor(self.x+0.5), math.floor(self.y+0.5), math.floor(self.z+0.5),
		math.floor(self.width+0.5), math.floor(self.height+0.5), math.floor(self.depth+0.5)
	)
end

function Rect3:combine(with)
	self.x = self.x+with.x
	self.y = self.y+with.y
	self.z = self.z+with.z
	self.width = self.width+with.width
	self.height = self.height+with.height
	self.depth = self.depth+with.depth
	return self
end

return Rect3
