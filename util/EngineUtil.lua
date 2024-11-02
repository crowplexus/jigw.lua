return {
	--- @param x number number of bytes to format.
	--- @param digits? number number of digits on the returning string, defaults to 2.
	--- @return string
	formatBytes = function(x, digits)
		if digits == nil or type(digits) ~= "string" then
			digits = 2
		end
		local units = { "B", "KB", "MB", "GB", "TB", "PB" }
		local unit = 3
		while x >= 1024 and unit < #units do
			x = x / 1024
			unit = unit + 1
		end
		return string.format("%." .. digits .. "f", x) .. units[unit]
	end,
	--- fake match/switch for lua
	match = function(prop, pat)
		if pat[prop] ~= nil then
			pat[prop]()
		elseif pat.default ~= nil then
			pat.default()
		end
	end,
	--- to draw text, that's it
	--- @param text string
	--- @param x number
	--- @param y number
	--- @param textColor? table<number>
	--- @param font? love.Font
	drawText = function(text, x, y, textColor, font)
		if not textColor then
			textColor = { 1, 1, 1, 1 }
		end
		if not font then
			font = love.graphics.getFont()
		end
		if not x then
			x = 0
		end
		if not y then
			y = 0
		end
		local nf = type(font) == "string" and love.graphics.newFont(font, 32) or font
		local text = love.graphics.newText(nf, text)
		love.graphics.setColor(textColor)
		love.graphics.draw(text, x, y)
		love.graphics.setColor(1, 1, 1, 1)
		-- free memory
		text:release()
		nf:release()
		text = nil
		nf = nil
	end,
	thousandSep = function(num, sep)
		if not num or type(num) ~= "number" then
			num = 0
		end
		if not sep or type(sep) ~= "string" then
			sep = ","
		end
		local numStr = tostring(math.abs(num))
		local prefix = num < 0 and "-" or ""
		local modPos = 3
		if #numStr <= modPos then
			return prefix .. numStr
		end
		local result = ""
		local digitPos = 0
		for i = #numStr, 1, -1 do
			digitPos = digitPos + 1
			result = string.sub(numStr, i, i) .. result
			if digitPos % modPos == 0 and i > 1 then
				result = sep .. result
			end
		end
		return prefix .. result
	end,
	--- Prints a stringified table.
	--- @param tbl table table to stringify
	--- @param indent number indentation level
	--- @param style string "yaml" or "json" - prints like a lua table if unspecified
	tablePrint = function(tbl, style, indent)
		indent = indent or 0
		local spacing = string.rep(" ", indent)

		local function printAsYaml(k, v)
			if type(v) == "table" then
				print(spacing .. tostring(k) .. ":")
				Utils.tablePrint(v, style, indent + 2)
			else
				print(spacing .. tostring(k) .. ": " .. tostring(v))
			end
		end

		local function printAsJson(k, v)
			if type(v) == "table" then
				print(spacing .. '"' .. tostring(k) .. '": {')
				Utils.tablePrint(v, style, indent + 2)
				print(spacing .. "}")
			else
				local vstr = type(v) == "string" and '"' .. tostring(v) .. '"' or tostring(v)
				print(spacing .. '"' .. tostring(k) .. '": ' .. vstr)
			end
		end

		local function printAsTable(k, v)
			if type(v) == "table" then
				print(spacing .. "" .. tostring(k) .. " =" .. " {")
				Utils.tablePrint(v, style, indent + 2)
				print(spacing .. "}")
			else
				local vstr = type(v) == "string" and '"' .. tostring(v) .. '"' or tostring(v)
				print(spacing .. tostring(k) .. " = " .. vstr)
			end
		end

		for k, v in pairs(tbl) do
			if style == "yaml" then
				printAsYaml(k, v)
			elseif style == "json" then
				printAsJson(k, v)
			else
				printAsTable(k, v)
			end
		end
	end,

	wrap = function(num, min, max)
		if not min or type(min) ~= "number" then
			min = 1
		end
		if not min or type(min) ~= "number" then
			max = 1
		end
		return num < min and max or num > max and min or num
	end,
	clamp = function(num, min, max)
		if not min or type(min) ~= "number" then
			min = 1
		end
		if not min or type(min) ~= "number" then
			max = 1
		end
		return num < min and min or num > max and max or num
	end,
	calculateFramerate = function(time, since, framerate)
		return 1 / framerate - (time - since)
	end,
}
