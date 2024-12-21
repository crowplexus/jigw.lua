-- ideally this shouldn't be a metatable just to serve as a base
-- but since I'm gonna extend it anyway, it doesn't matter

--- @class Object
local Object = Class("Object", {
    angle = 0,
    pos = Vec2(0, 0),
    scale = Vec2(0, 0),
    color = { 1, 1, 1, 1 },
    
})

return Object
