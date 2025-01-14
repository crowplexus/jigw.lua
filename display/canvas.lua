--- Draws objects added to it to the screen.
--- @class Canvas
local Canvas = Class("Canvas")

--- Initializes the canvas' variables.
function Canvas:init()
    self.objects = {}
    self.visible = true
    return self
end

--- Adds an object to the canvas.
--- @param o Class  The object to be added.
--- @return Class  The object added.
function Canvas:add(o)
    if self.objects and o then
        self.objects[#self.objects + 1] = o
    end
    return o
end

--- Removes an object from the canvas.
--- @param o Class  The object to be removed.
--- @return number  The index of the object removed, -1 if operation fails.
function Canvas:remove(o)
    if not self.objects then return end
    local ret = -1
    for i = 1, #self.objects do
        if self.objects[i] == o then
            self.objects[i] = nil
            table.remove(self.objects, i)
            ret = i
            break
        end
    end
    return ret
end

--- Updates all objects in the canvas.
--- @param dt number  The time passed since the last frame.
function Canvas:update(dt)
    if not self.objects or #self.objects == 0 then return end
    local i = 1
    while i <= #self.objects do
        if self.objects[i].update then -- can update
            self.objects[i]:update(dt)
        end
        i = i + 1
    end
end

function Canvas:getCamera()
    if not self.objects or #self.objects == 0 then return end
    for _, v in pairs(self.objects) do
        if string.find(tostring(v), "Camera") ~= -1 then
            return v
        end
    end
    return nil
end

--- Draws all objects in the canvas.
function Canvas:draw()
    if not self.visible or not self.objects or self.objects == 0 then
        return
    end
    local i = 1
    while i <= #self.objects do
        if self.objects[i].draw then -- can draw
            self.objects[i]:draw()
        end
        i = i + 1
    end
end

--- Disposes of all objects in the canvas.
function Canvas:dispose()
    if not self.objects or self.objects == 0 then return end
    local i = 1
    while i <= #self.objects do
        self.objects[i] = nil
        table.remove(self.objects, i)
        i = i + 1
    end
end

return Canvas
