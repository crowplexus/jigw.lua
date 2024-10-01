local ScreenHandler = {
  __name = "Screen Manager",
  activeScreen = nil, --- @class Screen
  transition = nil,
  skipNextTransIn = false,
  skipNextTransOut = false,
}

--- Unloads the current screen and loads a new one
--- @param modname string      Next screen module name
function ScreenHandler:switchScreen(modname)
  local nextScreen = require(modname)
  -- in case the transition isn't set
  if not ScreenHandler:willSkipTransition() and ScreenHandler.transition == nil then
    ScreenHandler.transition = DefaultScreenTransition
  end
  if ScreenHandler:isTransitionActive() then -- is set, has draw
    ScreenHandler.transition:reset()
    if ScreenHandler.skipNextTransOut == false then
      ScreenHandler.transition:outwards(true)
    end
  end
  local transitioned = true
  if ScreenHandler:isTransitionActive() then
    transitioned = false
    ScreenHandler.transition:reset()
    if ScreenHandler.skipNextTransIn == false then
      ScreenHandler.transition:inwards(true)
    end
  end

  local doSwitch = function()
    if type(nextScreen) == "table" and transitioned then
      -- clear the previous screen.
      if ScreenHandler:isScreenOperating() then
        ScreenHandler.activeScreen:clear()
        if ScreenHandler.activeScreen ~= nil then
          ScreenHandler.activeScreen = nil
        end
      end
      -- enable the requested screen.
      if nextScreen.new then ScreenHandler.activeScreen = nextScreen:new()
      else ScreenHandler.activeScreen = nextScreen end
    end
    -- now that the new screen is set, enter it.
    if ScreenHandler:isScreenOperating() and ScreenHandler.activeScreen.enter then
      ScreenHandler.activeScreen:enter()
    end
  end
  if transitioned == true then doSwitch()
  else -- TODO: make this take transition duration into account idk.
    Timer.create(0.3,function()
      transitioned = true
      doSwitch()
    end)
  end

  ScreenHandler.skipNextTransIn = false
  ScreenHandler.skipNextTransOut = false
end

function ScreenHandler:isTransitionActive()
  return ScreenHandler.transition ~= nil and ScreenHandler.transition.draw
end

function ScreenHandler:willSkipTransition()
  return ScreenHandler.skipNextTransOut and ScreenHandler.skipNextTransIn
end

function ScreenHandler:isScreenOperating()
  return ScreenHandler.activeScreen ~= nil
end

function ScreenHandler:getName()
  local named = ScreenHandler.activeScreen ~= nil and ScreenHandler.activeScreen.__name
  return named and ScreenHandler.activeScreen.__name or tostring(ScreenHandler.activeScreen)
end

return ScreenHandler
