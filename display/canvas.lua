--- Draws objects added to it to the screen.
--- @class Canvas
local Canvas = Class("Canvas")

function Canvas:init()
    self.objects = {}
    self.visible = true
    return self
end

function Canvas:add(o)
    if o then self.objects[#self.objects + 1] = o end
    return o
end

function Canvas:remove(o)
    for i = 1, #self.objects do
        if self.objects[i] == o then
            self.objects[i] = nil
            table.remove(self.objects, i)
            break
        end
    end
end

function Canvas:update(dt)
    if #self.objects == 0 then return end
    local i = 1
    while i <= #self.objects do
        if self.objects[i].update then -- can update
            self.objects[i]:update(dt)
        end
        i = i + 1
    end
end

function Canvas:draw()
    if not self.visible or self.objects == 0 then return end
    local i = 1
    while i <= #self.objects do
        if self.objects[i].draw then -- can draw
            self.objects[i]:draw()
        end
        i = i + 1
    end
end

function Canvas:dispose()
    local i = 1
    while i <= #self.objects do
        self.objects[i] = nil
        table.remove(self.objects, i)
        i = i + 1
    end
end

return Canvas
