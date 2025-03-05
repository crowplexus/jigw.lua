local PRIVATE_KEY, GETTER_KEY = "_", "get_"
local RESERVED_KEYWORDS = {"new", "delete", "_name", "__index", "__newindex"}
local function __getter(tbl, idx)
	local getter = rawget(tbl, "get_" .. idx)
	return getter and getter or tbl._super and __getter(tbl._super, idx) or nil
end
local function __setter(tbl, idx)
	local setter = rawget(tbl, "set_" .. idx)
	return setter and setter or tbl._super and  __setter(tbl._super, idx) or nil
end
-- Copies table A to B
local function copyTbl(a, b)
	local result = a or {}
	local orig = b or {}
	for k, v in pairs(orig) do
		if not result[k] and not RESERVED_KEYWORDS[k] then
			if type(v) == "table" then
				result[k] = copyTbl(v)
				--print("copied table "..k.. " from "..(orig._name or "Unknown(A)").." to "..(result._name or "Unknown(B)"))
			else
				result[k] = v
				--print("copied value "..k.. " from "..(orig._name or "Unknown(A)").." to "..(result._name or "Unknown(B)"))
			end
		end
	end
	return result
end

--- Basic class system for lua
--- @module engine.class
---
--- @usage Basic Class:
--- local MyClass = Class("MyClass") -- name can be empty (not recommended)
--- function MyClass:init()
---     self.value = 0
--- end
--- return MyClass
---
--- @usage Child Class:
--- local BaseClass = require("MyClass")
--- local ChildClass, super = Class("ChildClass", BaseClass) -- name can be `nil` (not recommended)
--- function ChildClass:init()
---     super.init(self)
---     self.value = 0
--- end
--- return ChildClass
---
--- @usage Property Getter/Setter
--- function MyClass:get_value()
---     return self.value
--- end
--- function MyClass:set_value(newvl)
---     self.value = newvl
--- end
--- 
--- @author crowplexus, pisayesiwsi
return function(name, base)
	-- TODO: reimplement reference counting
	base = base or {}
	local obj = {
		_name = name or ("AnonymousClass(" .. (base and tostring(base._name) or "") .. ")"),
		_members = base._members or {},
		_super = base._super or nil,
	}
	copyTbl(obj, base)
	obj.new = function(tbl, ...) -- тbl
		local wasInit = false
		super = tbl
		while not wasInit and super do -- safety check
			if super.init then
				super:init(...)
				wasInit = true
				break
			end
			super = tbl._super
		end
		--[[if tbl then -- not "nil" by the time init gets called
			--print("created " .. self._name .. "(ID:" .. self._id .. ")")
			obj._id = obj._id + 1
		end]]
		return tbl
	end
	obj.delete = function(tbl)
		if tbl.dispose then tbl:dispose() end
		--obj._id = obj._id - 1
		setmetatable(tbl, nil)
	end
	local meta = {
		__index = function(tbl, idx)
			if string.sub(idx, 1, 2) == PRIVATE_KEY or string.sub(idx, 1, 4) == GETTER_KEY then
				return rawget(tbl, idx)
			end
			local propgetter = __getter(tbl, idx)
			if propgetter then
				print("calling " .. idx .. " getter")
				local ismt = getmetatable(tbl)
				return ismt and propgetter(tbl) or propgetter()
			else
				return rawget(tbl._members, idx) or (tbl._super and rawget(tbl._super, idx))
			end
		end,
		__newindex = function(tbl, idx, val)
			if string.sub(idx, 1, 2) == "__" or string.sub(idx, 1, 4) == "set_" then
				rawset(tbl, idx, val)
				return
			end
			local propsetter = __setter(tbl, idx)
			if propsetter then
				print("calling " .. idx .. " setter")
				local ismt = getmetatable(tbl)
				if ismt then
					propsetter(tbl, val)
				else
					propsetter(val)
				end
				return
			end
			rawset(tbl._members, idx, val)
		end,
		__tostring = function(tbl)
			local nm = string.sub(tbl._name, 0, #tbl._name)
			return "Class \""..nm.."\""..(tbl._super and " Child of \""..tbl._super._name.."\"" or "")
		end,
	}
	setmetatable(obj, mt)
	return obj, base
end
