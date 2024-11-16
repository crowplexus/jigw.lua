--- Contains fields to define which direction the bar foreground goes to
--- @enum ProgressFill
ProgressFill = {
	LTR = 0, --- @type number Left to Right
	RTL = 1, --- @type number Right to Left
	TTB = 2, --- @type number Top to Bottom
	BTT = 3, --- @type number Bottom to Top
}

--- @enum Axis
Axis = {
	X = 0x01,
	Y = 0x02,
	XY = 0x03,
}

--- @enum ShapeType
ShapeType = {
	RECTANGLE = 1,
	CIRCLE = 2,
}
