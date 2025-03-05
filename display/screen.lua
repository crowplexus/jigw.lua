-- screens are just a canvas with additional functions.

--- @class Screen
local Screen, super = Class("Screen", Canvas)

--- Called whenever the screen gets initialised and the game switches to it.
function Screen:enter() end

--- Resizes the screen to the new dimensions.
--- @param w number  The new width.
--- @param h number  The new height.
function Screen:resize(w, h) end

--- Called when a key is pressed, only works if there are any objects on the screen.
--- @param key string  The key pressed.
--- @param scancode string  The scancode of the key.
--- @param isrepeat boolean  If the key is being held down.
function Screen:keypressed(key, scancode, isrepeat)
	if #self.objects == 0 then return end
	local i = 1
	while i <= #self.objects do
		if self.objects[i].keypressed then
			self.objects[i]:keypressed(key, scancode, isrepeat)
		end
		i = i + 1
	end
end

--- Called when a key is released, only works if there are any objects on the screen.
--- @param key string  The key released.
function Screen:keyreleased(key)
	if #self.objects == 0 then return end
	local i = 1
	while i <= #self.objects do
		if self.objects[i].keyreleased then
			self.objects[i]:keyreleased(key)
		end
		i = i + 1
	end
end

--- @see Canvas.dispose
--- @type function
function Screen:exit()
	return super.dispose(self)
end

return Screen
