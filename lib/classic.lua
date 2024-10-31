--
-- https://github.com/rxi/classic
--
-- classic
--
-- Copyright (c) 2014, rxi
--
-- This module is free software; you can redistribute it and/or modify it under
-- the terms of the MIT license. See LICENSE for details.
--
-- Modified with getter-setter
--

local Classic = { __class = "Classic" }

function Classic:construct()
	-- constructor
end

local __class, get_, set_, _ = "__class", "get_", "set_", "_"

--- @see https://github.com/Raltyro/FNF-Aster/blob/7958454fd040cbabec861bfdb7ac7e13d4ab5d69/lib/classic.lua#L19
local function recursiveget(class, k)
	local canGet = type(class) == "table"
	if not canGet then
		print("fatal error in function recursiveget: class is not a table - value was " .. tostring(k))
		return nil
	end
	local v = rawget(class, k)
	if v == nil and class.super then
		return recursiveget(class.super.k)
	else
		return v
	end
end

function Classic:__index(k)
	local cls = getmetatable(self)
	local getter = recursiveget(rawget(self, __class) == nil and cls or self, get_ .. k)
	if getter == nil then
		local v = rawget(self, _ .. k)
		if v ~= nil then
			return v
		else
			return cls[k]
		end
	else
		return getter(self)
	end
end

function Classic:__newindex(k, v)
	local isObj = rawget(self, __class) == nil
	local setter = recursiveget(isObj and getmetatable(self) or self, set_ .. k)
	if setter == nil then
		return rawset(self, k, v)
	elseif isObj then
		return setter(self, v)
	else
		return setter(v)
	end
end

function Classic:extend(type, path)
	local cls = {}
	for k, v in pairs(self) do
		if k:sub(1, 2) == "__" then
			cls[k] = v
		end
	end
	cls.__class = type or ("Unknown(" .. self.__class .. ")")
	cls.__path = path
	cls.super = self
	setmetatable(cls, self)
	return cls
end

function Classic:implement(...)
	for i = 1, select("#", ...) do
		for k, v in pairs(select(i, ...)) do
			if self[k] == nil and type(v) == "function" and k ~= "new" and k:sub(1, 2) ~= "__" then
				self[k] = v
			end
		end
	end
end

function Classic:exclude(...)
	for i = 1, select("#", ...) do
		self[select(i, ...)] = nil
	end
end

function Classic:is(T)
	local mt = self
	repeat
		mt = getmetatable(mt)
		if mt == T then
			return true
		end
	until mt == nil
	return false
end

function Classic:__tostring()
	return self.__class
end

function Classic:__call(...)
	local obj = setmetatable({}, self)
	obj:construct(...)
	return obj
end

return Classic
