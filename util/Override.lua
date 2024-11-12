require("jigw.util.StringUtil")
require("jigw.util.TableUtils")

local luaPrint = print

---
---Receives any number of arguments and prints their values to `stdout`, converting each argument to a string following the same rules of [tostring](command:extension.lua.doc?["en-us/54/manual.html/pdf-tostring"]).
---The function print is not intended for formatted output, but only as a quick way to show a value, for instance for debugging. For complete control over the output, use [string.format](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.format"]) and [io.write](command:extension.lua.doc?["en-us/54/manual.html/pdf-io.write"]).
---
---
---[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-print"])
---
---@param ... any
function print(...)
	local ginfo = debug.getinfo(2, "Sl")
	local source, line = ginfo.short_src, ginfo.currentline
	local info = ...
	-- TODO: gotta implement tableprint here somehow
	luaPrint(string.format("[%s:%d] %s", source, line, info))
end

--[[
if not table.move then
	function table.move(a, f, e, t, b)
		b = b or a
		for i = f, e do
			b[i + t - 1] = a[i]
		end
		return b
	end
end

function table.find(t, value)
	for i = 1, #t do
		if t[i] == value then
			return i
		end
	end
end

local __number__ = "number"
local table_remove = table.remove
	or function(t, pos)
		local n = #t
		if pos == nil then
			pos = n
		end
		local v = t[pos]
		if pos < n then
			table_move(t, pos + 1, n, pos)
		end
		t[n] = nil
		return v
	end
function table.remove(list, idx)
	if idx == nil or type(idx) == __number__ then
		return table_remove(list, idx)
	end
	local j, v = 1
	for i = j, #list do
		if list[i] and idx(list, i, j) then
			v, list[i] = list[i]
		else
			if i ~= j then
				list[j], list[i] = list[i]
			end
			j = j + 1
		end
	end
	return v
end

function table:has(val)
	for i, v in next, self do
		if v == val then
			return true
		end
	end
	return false
end
]]

function math.round(x)
	return math.floor(x + 0.5)
end
