local ScreenManager = {
	__name = "Screen Handler",
	activeScreen = nil, --- @class jigw.Screen
	transition = nil,
	skipNextTransIn = false,
	skipNextTransOut = false,
	inTransition = false,
}

--- Unloads the current screen and loads a new one
--- @param modname string      Next screen module name.
--- @param ... any             Screen constructor arguments.
function ScreenManager:switchScreen(modname, ...)
	local nextScreen = require(modname)
	local args = ...

	-- in case the transition isn't set
	if not ScreenManager.skipTransitions() and ScreenManager.transition == nil then
		ScreenManager.transition = DefaultScreenTransition
	end

	local transitioned = true

	-- transition outwards (animation)
	if ScreenManager.canTransition() then -- is set, has draw
		transitioned = false
		ScreenManager.transition:reset()
		if ScreenManager.skipNextTransOut == false then
			ScreenManager.transition:outwards(true)
			self.inTransition = true
		end
	end
	-- transition inwards (animation)
	if ScreenManager.canTransition() then
		transitioned = false
		ScreenManager.transition:reset()
		if ScreenManager.skipNextTransIn == false then
			ScreenManager.transition:inwards(true)
			self.inTransition = true
		end
	end

	local doSwitch = function(...)
		if type(nextScreen) == "table" and transitioned then
			-- clear the previous screen.
			if ScreenManager:isScreenOperating() then
				ScreenManager.activeScreen:clear()
				if ScreenManager.activeScreen ~= nil then
					ScreenManager.activeScreen = nil
				end
			end
			ScreenManager.activeScreen = nextScreen(args)
		end
		-- now that the new screen is set, enter it.
		if ScreenManager:isScreenOperating() and ScreenManager.activeScreen.enter then
			ScreenManager.activeScreen:enter()
		end
	end

	if transitioned == true then
		doSwitch()
	else -- TODO: make this take transition duration into account idk.
		Timer.create(0.3, function()
			self.inTransition = false
			transitioned = true
			doSwitch()
		end)
	end

	ScreenManager.skipNextTransIn = false
	ScreenManager.skipNextTransOut = false
end

function ScreenManager.canTransition()
	return ScreenManager.transition ~= nil and ScreenManager.transition.draw
end

function ScreenManager.skipTransitions()
	return ScreenManager.skipNextTransOut and ScreenManager.skipNextTransIn
end

function ScreenManager:isScreenOperating()
	return ScreenManager.activeScreen ~= nil
end

function ScreenManager:getName()
	local named = ScreenManager.activeScreen ~= nil and ScreenManager.activeScreen.__name
	return named and ScreenManager.activeScreen.__name or tostring(ScreenManager.activeScreen)
end

return ScreenManager
