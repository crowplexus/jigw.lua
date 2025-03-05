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
--- @author crowplexus AKA IamMorwen
return function(name, base)
	local function __gettersearch(self, idx)
		local getter = rawget(self, "get_" .. idx)
		return getter and getter or self.__super and
				   __gettersearch(self.__super, idx) or nil
	end
	local function __settersearch(self, idx)
		local setter = rawget(self, "set_" .. idx)
		return setter and setter or self.__super and
				   __settersearch(self.__super, idx) or nil
	end

	local o = {
		__name = name or
			("AnonymousClass(" .. (base and tostring(base) or "") .. ")"),
		__callbacks = {},
		__members = {},
		__super = nil,
		__id = 1
	}

	if type(base) == "table" then
		for k, v in pairs(base.__members or {}) do
			-- print("added " .. k .. " into " .. o.__name .. " from " .. base.__name)
			o.__members[k] = v
		end
		for k, v in pairs(base.__callbacks or {}) do
			-- print("added " .. k .. " into " .. o.__name .. " from " .. base.__name)
			o.__callbacks[k] = v
		end
		o.__super = base
	end

	o.new = function(self, ...)
		local instance = setmetatable({}, {__index = self})
		if instance.init then instance:init(...) end
		if instance then -- not "nil" by the time init gets called
			-- print("created " .. self.__name .. "(" .. self.__id .. ")")
			o.__id = o.__id + 1
		end
		return instance
	end
	o.delete = function(self)
		if self.dispose then self:dispose() end
		self.__id = self.__id - 1
		setmetatable(self, nil)
	end

	local mt = setmetatable(o, {
		__index = function(self, idx)
			if string.sub(idx, 1, 2) == "__" or string.sub(idx, 1, 4) == "get_" then
				return rawget(self, idx)
			end
			local propgetter = __gettersearch(self, idx)
			if propgetter then
				print("calling " .. idx .. " getter")
				local ismt = getmetatable(self)
				return ismt and propgetter(self) or propgetter()
			else
				return rawget(self.__members, idx) or
						   rawget(self.__callbacks, idx) or
						   (self.__super and rawget(self.__super, idx))

			end
		end,
		__newindex = function(self, idx, val)
			if string.sub(idx, 1, 2) == "__" or string.sub(idx, 1, 4) == "set_" then
				rawset(self, idx, val)
				return
			end
			local propsetter = __settersearch(self, idx)
			if propsetter then
				print("calling " .. idx .. " setter")
				local ismt = getmetatable(self)
				if ismt then
					propsetter(self, val)
				else
					propsetter(val)
				end
				return
			end
			if type(val) == "function" then
				rawset(self.__callbacks, idx, val)
			else
				rawset(self.__members, idx, val)
			end
		end,
		__tostring = function(self)
			local id = "Instance: " .. self.__id
			local nm = string.sub(self.__name, 0, #self.__name - 1)
			return "Name: " .. nm .. tostring(base or "") .. ") - " .. id
		end
	})
	return mt, base
end
