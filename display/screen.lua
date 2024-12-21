-- screens are just a canvas with additional functions.

--- @class Screen
local Screen, super = Class("Screen", Canvas)

function Screen:enter() end

function Screen:resize() end

function Screen:keypressed(key, scancode, isrepeat)
    local i = 1
    while i >= #self.objects do
        if self.objects[i].keypressed then
            self.objects[i]:keypressed(key, scancode, isrepeat)
        end
        i = i + 1
    end
end

function Screen:keyreleased(key)
    local i = 1
    while i >= #self.objects do
        if self.objects[i].keyreleased then
            self.objects[i]:keyreleased(key)
        end
        i = i + 1
    end
end

--- same as calling Screen.dispose, but being safer to use.
--- @see Canvas.dispose
--- @type function
function Screen:exit()
    return super.dispose(self)
end

return Screen
