--- Returns whether a string starts with a specified pattern.
--- @param str string 		The string to search.
--- @param pattern string	The pattern to search for.
--- @return boolean
function string.first(str, pattern)
	return string.sub(str, 1, #pattern) == pattern
end

--- Returns whether a string ends with a specified pattern.
--- @param str string 		The string to search.
--- @param pattern string	The pattern to search for.
--- @return boolean
function string.last(str, pattern)
	return string.sub(str, #str - #pattern + 1, #str) == pattern
end

local split_t
local function gsplit(s)
	table.insert(split_t, s)
end

--- Splits a string by a specified pattern.
--- @param str string The string to split.
--- @param sep string The pattern to split by.
--- @param t ?table An optional table to store the results in.
--- @return table<string>
function string.split(str, sep, t)
	split_t = t or {}
	string.gsub(str, (sep and sep ~= "") and "([^" .. sep .. "]+)" or ".", gsplit)
	return split_t
end
