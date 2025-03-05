--- Helper class that assigns generic IDs to keycodes,
--- this is useful for handling input without the hassle of having to check keycodes manually.
--- @class Input
local Input = {
	--- A table that maps action IDs to keycodes.
	--- @type table<string, string[]>
	actions = {
		["ui_left"] = { "left" },
		["ui_right"] = { "right" },
		["ui_up"] = { "up" },
		["ui_down"] = { "down" },
		["ui_confirm"] = { "return" },
		["ui_cancel"] = { "escape" },
	},
	--- If true, input will be update in love.update
	--- @type boolean
	globalUpdate = true,
}

--- Checks if an action is currently not being pressed
--- @param action string Action ID (e.g: "ui_left")
--- @return boolean
function Input.up(action)
	for i = 1, #Input.actions[action] do
		return love.keyboard.isUp(Input.actions[action][i])
	end
	return false
end

--- Checks if an action is currently being pressed
--- @param action string Action ID (e.g: "ui_left")
--- @return boolean
function Input.down(action)
	for i = 1, #Input.actions[action] do
		return love.keyboard.isDown(Input.actions[action][i])
	end
	return false
end

--- Checks if an action is currently being pressed and returns a number between -1 and 1
--- @param actionA string Action ID (e.g: "ui_left")
--- @param actionB string Action ID (e.g: "ui_right")
--- @return number
function Input.axis(actionA, actionB)
	return Input.down(actionA) and -1 or Input.down(actionB) and 1 or 0
end

--- Checks if an action exists in the Input.actions table
--- @param name string Action ID (e.g: "ui_left")
--- @return boolean
function Input.has(name)
	return Input.actions[name] ~= nil
end

--- Adds a key (or multiple keys if a table is specified) to an action
--- @param action string Action ID (e.g: "ui_left")
--- @param key table|string KeyCode or table of KeyCodes (e.g: "space" or { "space", "z" })
function Input.add(action, key)
	Input.actions[action] = type(key) == "table" and key or { key }
end

--- Adds a key to an existing action.
--- @param action string Action ID (e.g: "ui_left")
--- @param key string KeyCode (e.g: "space")
function Input.insert(action, key)
	table.insert(Input.actions[action], key)
end

return Input
