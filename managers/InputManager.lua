local InputManager = {
  -- Table with currently pressed keycodes
  pressed   = {},
  -- If the Input Manager should operate or not.
  active    = true,
  -- Pauses the Input Manager during transitions
  autoPause = true,
  -- ...
  boundActions = {
    ["ui_left"]   = {"left"},
    ["ui_down"]   = {"down"},
    ["ui_up"]     = {"up"},
    ["ui_right"]  = {"right"},
    ["ui_accept"] = {"return"},
    ["ui_pause"]  = {"backspace"},
  },
}

--- Binds an action to new keycodes, unsafe version of InputManager.rebindAction.
--- @param action string                Action to rebind.
--- @param keyCodes table<string>       New Keycodes to use for the action.
function InputManager.bindAction(action, keyCodes)
  InputManager.boundActions[action] = keyCodes
end

--- Rebinds an action to new keycodes.
--- @param action string                Action to rebind.
--- @param keyCodes table<string>       New Keycodes to use for the action.
function InputManager.rebindAction(action, keyCodes)
  InputManager.boundActions[action] = keyCodes or InputManager.boundActions[action]
end

--- Returns either 1 or -1 based on which keycode is being held
--- @param positiveKey string       Positive KeyCode (1)
--- @param negativeKey string       Negative KeyCode (-1)
--- @@return number
function InputManager.getAxis(positiveKey,negativeKey)
  if InputManager.pressed[positiveKey] == true then return 1
  elseif InputManager.pressed[negativeKey] == true then return -1
  else return 0 end
end

--- Returns either 1 or -1 based on which action is being held
--- @param positiveAct string       Positive ActionCode (1)
--- @param negativeAct string       Negative ActionCode (-1)
--- @@return number
function InputManager.getActionAxis(positiveAct,negativeAct)
  local pa = InputManager.boundActions[tostring(positiveAct)]
  local na = InputManager.boundActions[tostring(negativeAct)]
  for i=1,#pa do
    local key = pa[i]
    if InputManager.pressed[key] then return 1 end
  end
  for i=1,#na do
    local key = na[i]
    if InputManager.pressed[key] then return -1 end
  end
  return 0
end

--- Returns whether a keycode or was being held in the last frame.
--- @param keyCode string       Desired keycode (string) to check for.
--- @param checkActions boolean Checks for InputManager.boundActions instead, the keycode should be an action code (i.e: ui_up).
--- @@return boolean
function InputManager.getJustPressed(keyCode,checkActions)
  local kc = keyCode
  if checkActions == true then
    for i=1,#InputManager.boundActions[kc] do
      local key = InputManager.boundActions[kc][i]
      return InputManager.pressed[key] == true
    end
  else
    return InputManager.pressed[kc] == true or false
  end
end

--- Returns whether a keycodes is being pressed in the current frame.
--- @param keyCode string       Desired keycode to check for, or action code.
--- @param checkActions boolean Checks for InputManager.boundActions instead, the keycode should be an action code (i.e: ui_up).
--- @@return boolean
function InputManager.getPressed(keyCode,checkActions)
  local kc = keyCode
  if checkActions == true then
    for i=1,#InputManager.boundActions[kc] do
      local key = InputManager.boundActions[kc][i]
      return love.keyboard.isDown(key) == false
    end
  else
    return love.keyboard.isDown(kc) or false
  end
end

--- Returns whether a keycode was released in the last frame.
--- @param keyCode string       Desired keycode to check for, or action code.
--- @param checkActions boolean Checks for InputManager.boundActions instead, the keycode should be an action code (i.e: ui_up).
--- @@return boolean
function InputManager.getJustReleased(keyCode,checkActions)
  local kc = keyCode
  if checkActions == true then
    for i=1,#InputManager.boundActions[kc] do
      local key = InputManager.boundActions[kc][i]
      return InputManager.pressed[key] == false
    end
  else
    return InputManager.pressed[kc] == false or false
  end
end

--- Returns whether multiple keycodes were pressed in the last frame.
--- @param keyCodes table<string>|string      table with keycodes, or action code
--- @param checkActions boolean Checks for InputManager.boundActions instead, the keycode should be an action code (i.e: ui_up).
--- @@return boolean
function InputManager.getAnyJustPressed(keyCodes,checkActions)
  local kc = keyCodes
  if checkActions == true then
    for i=1,#InputManager.boundActions[kc] do
      local key = InputManager.boundActions[kc][i]
      return InputManager.pressed[key] == true
    end
  else
    local result = false
    if type(kc) ~= "table" then return result end
    for i=1,#kc do
      local key = kc[i]
      local valid = InputManager.pressed[tostring(key)] == true
      if valid == true then
        result = valid
        break
      end
    end
  end
  return result
end

--- Returns whether multiple keycodes are being pressed in the current frame.
--- @param keyCodes table<string>|string      table with keycodes, or action code
--- @param checkActions boolean Checks for InputManager.boundActions instead, the keycode should be an action code (i.e: ui_up).
--- @@return boolean
function InputManager.geAnyPressed(keyCodes,checkActions)
  local kc = keyCodes
  if checkActions == true then
    for i=1,#InputManager.boundActions[kc] do
      local key = InputManager.boundActions[kc][i]
      return love.keyboard.isDown(key) == true
    end
  else
    local result = false
    if type(kc) ~= "table" then return result end
    for i=1,#kc do
      local key = kc[i]
      local valid = love.keyboard.isDown(tostring(key))
      if valid == true then
        result = valid
        break
      end
    end
  end
  return result
end

--- Returns whether multiple keycodes were released in the last frame.
--- @param keyCodes table<string>|string      table with keycodes, or action code
--- @param checkActions boolean Checks for InputManager.boundActions instead, the keycode should be an action code (i.e: ui_up).
--- @@return boolean
function InputManager.geAnyJustReleased(keyCodes,checkActions)
  local kc = keyCodes
  if checkActions == true then
    for i=1,#InputManager.boundActions[kc] do
      local key = InputManager.boundActions[kc][i]
      return InputManager.pressed[key] == false
    end
  else
    local result = false
    if type(kc) ~= "table" then return result end
    for i=1,#kc do
      local key = kc[i]
      local valid = InputManager.pressed[tostring(key)] == false
      if valid == true then
        result = valid
        break
      end
    end
  end
  return result
end

return InputManager