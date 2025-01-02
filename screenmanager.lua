--- Manages screen switching and transitions.
--- @class ScreenManager
local ScreenManager = Class("ScreenManager")

function ScreenManager:initialize()
    self.screens = {}
    self.activeScreen = nil
    self.overlays = {}
end

--- Adds a screen to the screen manager.
--- @param screen Screen The screen to add.
--- @param name string The name of the screen.
function ScreenManager:addScreen(screen, name)
    self.screens[name or screen.name] = screen
end

--- Adds an overlay to the screen manager.
--- @param overlay Overlay The overlay to add.
function ScreenManager:addOverlay(overlay)
    table.insert(self.overlays, overlay)
end

--- Switches to a screen.
--- @param name string The name of the screen to switch to.
function ScreenManager:switchScreen(name)
    if self.activeScreen then
        self.activeScreen:exit()
        self.activeScreen = nil
    end
    self.activeScreen = self.screens[name]
    self.activeScreen:enter()
end

--- Updates the active screen.
--- @param dt number The delta time.
function ScreenManager:update(dt)
    if self.activeScreen then
        self.activeScreen:update(dt)
    end
end

--- Handles key presses.
--- @param key string The key that was pressed.
--- @param scancode string The scancode of the key.
--- @param isrepeat boolean Whether the key press is a repeat.
function ScreenManager:keypressed(key, scancode, isrepeat)
    if self.activeScreen then
        self.activeScreen:keypressed(key, scancode, isrepeat)
    end
end

--- Handles key releases.
--- @param key string The key that was released.
function ScreenManager:keyreleased(key)
    if self.activeScreen then
        self.activeScreen:keyreleased(key)
    end
end

--- Draws the active screen and overlays.
function ScreenManager:draw()
    if self.activeScreen then
        self.activeScreen:draw()
    end
    for _, overlay in pairs(self.overlays) do
        overlay:draw()
    end
end

return ScreenManager