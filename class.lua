local IMPORTANT_KEY, GETTER_KEY, SETTER_KEY = "_", "get_", "set_"
local RESERVED_KEYS = { "new", "delete", "_super", "_name", "_members", "__index", "__newindex" }
-- all of the "visited" tables here are used to prevent infinite recursion

local function __getrecursive(self, idx, visited)
	visited = visited or {}
	if visited[self] then return nil end
	visited[self] = true
	local value = rawget(self, idx)
	if not value and self._super then
		return __getrecursive(self._super, idx, visited)
	end
	return value
end

local function __getter(self, idx, visited) return __getrecursive(self, GETTER_KEY .. idx, visited) end
local function __setter(self, idx, visited) return __getrecursive(self, SETTER_KEY .. idx, visited) end

-- Copies properties from table B to table A.
local function copyTbl(a, b)
	local result = a or {}
	local orig = b or {}
	for k, v in pairs(orig) do
		local reserved = false
		for i = 1, #RESERVED_KEYS do
			if k == RESERVED_KEYS[i] then
				reserved = true
				break
			end
		end
		if not reserved and not result[k] then
			if type(v) == "table" then
				result[k] = copyTbl(result[k] or {}, v)
			else
				result[k] = v
			end
			print("copied " .. tostring(k) .. " to " .. tostring(result._name or "UnknownClass"))
		end
	end
	local mt = getmetatable(orig)
	if mt and not getmetatable(result) then
		setmetatable(result, mt)
	end
	return result
end

return function(name, base)
	local obj = {
		_name = name or ("AnonymousClass(" .. (base and tostring(base._name) or "") .. ")"),
		_super = type(base) == "table" and base or nil,
		_members = {},
		--_id = 1,
	}
	if obj._super ~= nil then
		obj = copyTbl(obj, obj._super)
	end
	obj.new = function(self, ...)
		if self.init then
			self:init(...)
		end
		local instance = setmetatable({ _members = {} }, { __index = self })
		--obj._id = obj._id + 1
		return instance
	end
	obj.delete = function(self)
		if self.dispose then self:dispose() end
		if getmetatable(self) then
			setmetatable(self, nil)
			--obj._id = obj._id - 1
		end
	end
	local mt = setmetatable(obj, {
		__index = function(self, idx)
			if string.sub(idx, 1, #IMPORTANT_KEY) == IMPORTANT_KEY or string.sub(idx, 1, #GETTER_KEY) == GETTER_KEY then
				return rawget(self, idx)
			end
			local propgetter = __getter(self, idx)
			if propgetter then
				return getmetatable(self) and propgetter(self) or propgetter()
			else
				return rawget(self._members, idx) or (self._super and rawget(self._super._members, idx))
			end
		end,
		__newindex = function(self, idx, val)
			if string.sub(idx, 1, #IMPORTANT_KEY) == IMPORTANT_KEY or string.sub(idx, 1, #SETTER_KEY) == SETTER_KEY then
				rawset(self, idx, val)
				return
			end
			local propsetter = __setter(self, idx)
			if propsetter then
				if getmetatable(self) then propsetter(self, val)
				else propsetter(val) end
			else
				rawset(self._members, idx, val)
			end
		end,
		__tostring = function(self)
			local nm = string.sub(self._name, 0, #self._name)
			return "Class \""..nm.."\""..((self._super and self._super._name) and " Child of \""..self._super._name.."\"" or "")
				--.." ID "..self._id
		end,
	})
	return mt, obj._super
end
