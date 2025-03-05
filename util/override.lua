if arg[2] == "debug" then require("lldebugger").start() end

require("engine.util.stringutil")
require("engine.util.mathutil")

local luaprint = print

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
	if string.find(tostring(info), "^" .. "table?") ~= nil then
		luaprint(string.format("[%s:%d]: %s", source, line, info))
		if type(info) ~= "table" then
			return
		end
		local indent = 2
		local spacing = string.rep(" ", 1)
		for k, v in pairs(info) do
			if type(v) == "table" then
				luaprint(spacing .. "" .. tostring(k) .. " =" .. " {")
				luaprint(v, style, indent + 2)
				luaprint(spacing .. "}")
			else
				local vstr =
					type(v) == "string" and '"' .. tostring(v) .. '"' or
						tostring(v)
				luaprint(spacing .. tostring(k) .. " = " .. vstr)
			end
		end
	else
		luaprint(string.format("[%s:%d]: %s", source, line, info))
	end
end
