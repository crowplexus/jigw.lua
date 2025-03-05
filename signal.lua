--- A signal is a way to call multiple functions at once.
--- @class Signal
local Signal = Class("Signal")

function Signal:init()
	for i = 1, #Signal.funcs do Signal.funcs[i] = nil end
	Signal.funcs = {}
	return self
end

--- Adds a function to the signal.
--- @param func function
--- @param idx? number
function Signal:addFunc(func, idx)
	idx = idx or #Signal.funcs + 1
	Signal.funcs[idx] = func
end

--- Removes a functions from the signal.
--- @param idx number
function Signal:removeFunc(idx)
	Signal.funcs[idx] = nil
end

--- Tries to find a function on the signal.
--- @param func function
function Signal:findFunc(func)
	for i = 1, #Signal.funcs do
		if Signal.funcs[i] == func then
			return i
		end
	end
	return nil
end

return Signal
