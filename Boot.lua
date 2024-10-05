local Boot = {}

--- Sets up the jigw library and initialises it, allowing you to safely use it
---
--- ```lua
--- function love.load()
--- require("jigw.Boot").init()
--- end
--- ```
function Boot.init()
	--- overrides some lua functions for extending functionality
	require("jigw.util.Override")
	--- Globals ---
	_G.GlobalTweens = {}     --- @type table<Tween>
	_G.GlobalTimers = {}     --- @type table<Timer>
	--- Constants ---
	_G.JIGW_VERSION = "1.0.0" --- @type string
	--_G.jigw = {

	Object = require("jigw.lib.classic")  --- @class jigw.Object
	Screen = require("jigw.Screen")       --- @class jigw.Screen
	Vector2 = require("jigw.util.Vector2") --- @class jigw.Vector2
	Vector3 = require("jigw.util.Vector3") --- @class jigw.Vector3
	Rect2 = require("jigw.util.Rect2")    --- @class jigw.Rect2
	Rect3 = require("jigw.util.Rect3")    --- @class jigw.Rect3
	ScreenTransitions = {
		Circle = require("jigw.transition.Circle"),
		Rectangle = require("jigw.transition.Rectangle"),
	}
	DefaultScreenTransition = ScreenTransitions.Circle

	Color = require("jigw.util.Color")           --- @class jigw.Color
	ScreenHandler = require("jigw.ScreenHandler") --- @class jigw.ScreenHandler
	Utils = require("jigw.util.EngineUtils")     --- @class jigw.Utils
	Timer = require("jigw.util.Timer")           --- @class jigw.Timer
	Tween = require("jigw.lib.tween")            --- @class jigw.Tween
	Sound = require("jigw.Sound")                --- @class jigw.Sound

	--}

	return _G.JIGW_VERSION ~= nil and true or false
end

function Boot.update(dt)
	local screenPaused = ScreenHandler.inTransition
	if not screenPaused and ScreenHandler:isScreenOperating() and ScreenHandler.activeScreen.update then
		ScreenHandler.activeScreen:update(dt)
	end
	if Timer and #_G.GlobalTimers ~= 0 then
		local i = 1;
		while (i <= #_G.GlobalTimers) do
			local timer = _G.GlobalTimers[i];
			timer:update(dt);
			if timer.finished and timer.oneshot then
				table.remove(_G.GlobalTimers, i)
				--print('removed timer at ', i)
			end
			i = i + 1;
		end
	end
	if Tween and #_G.GlobalTweens ~= 0 then
		local i = 1;
		while i <= #_G.GlobalTweens do
			local tween = _G.GlobalTweens[i];
			tween:update(dt);
			if (_G.GlobalTweens[i].clock >= _G.GlobalTweens[i].duration) then
				table.remove(_G.GlobalTweens, i);
				--print('removed tween at ', i)
				return;
			end
			i = i + 1;
		end
	end
	if Sound and Sound.update then Sound.update(dt) end
end

function Boot.keypressed(key)
	local screenPaused = ScreenHandler.inTransition
  if not screenPaused and ScreenHandler:isScreenOperating() and ScreenHandler.activeScreen.keypressed then
    ScreenHandler.activeScreen:keypressed(key)
  end
end

function Boot.keyreleased(key)
	local screenPaused = ScreenHandler.inTransition
  if not screenPaused and ScreenHandler:isScreenOperating() and ScreenHandler.activeScreen.keyreleased then
    ScreenHandler.activeScreen:keyreleased(key)
  end
end

function Boot.showSplash() end

function Boot.deinit() end

return Boot
