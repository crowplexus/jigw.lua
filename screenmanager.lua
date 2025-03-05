--- Manages screen switching and transitions.
--- @class ScreenManager
local ScreenManager = Class("ScreenManager")

local _camera = nil
function ScreenManager:getCamera()
	if not _camera then
		_camera = ScreenManager.activeScreen:getCamera()
	end
	return _camera
end

function ScreenManager:initialize()
	self.activeScreen = nil
	self.overlays = {}
end

--- Adds an overlay to the screen manager.
--- @param overlay Overlay The overlay to add.
function ScreenManager:addOverlay(overlay)
	table.insert(self.overlays, overlay)
end

--- Switches to a screen.
--- @param path string The module path of the screen to switch to.
function ScreenManager:switchScreen(path)
	if self.activeScreen then
		self.activeScreen:exit()
		self.activeScreen = nil
		_camera = nil
	end
	if type(path) == "string" then
		self.activeScreen = require(path)
		if self.activeScreen then self.activeScreen:new() end
	elseif type(path) == "userdata" then
		self.activeScreen = path
	end
	if self.activeScreen then
		self.activeScreen:enter()
	else
		error("Failed to initialize screen \""..tostring(path).."\"")
	end
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
	if self.activeScreen and self.activeScreen.visible then
		self.activeScreen:draw()
	end
	for _, overlay in pairs(self.overlays) do
		overlay:draw()
	end
end

return ScreenManager