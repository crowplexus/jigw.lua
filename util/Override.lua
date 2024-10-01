--- @return boolean
function string:last(pattern)
  return (self:sub(#self - #pattern + 1, #self) == pattern);
end

local split_t
local function gsplit(s) table.insert(split_t, s) end
--- @return table<string>
function string:split(sep, t)
  split_t = t or {}
  self:gsub((sep and sep ~= "") and "([^" .. sep .. "]+)" or ".", gsplit)
  return split_t
end

if not table.move then
  function table.move(a, f, e, t, b)
    b = b or a; for i = f, e do b[i + t - 1] = a[i] end
    return b
  end
end
function table.find(t, value) for i = 1, #t do if t[i] == value then return i end end end

local __number__ = "number"
local table_remove = table.remove or function(t, pos)
  local n = #t; if pos == nil then pos = n end;
  local v = t[pos]; if pos < n then table_move(t, pos + 1, n, pos) end;
  t[n] = nil; return v
end
function table.remove(list, idx)
  if idx == nil or type(idx) == __number__ then return table_remove(list, idx) end
  local j, v = 1
  for i = j, #list do
    if list[i] and idx(list, i, j) then
      v, list[i] = list[i]
    else
      if i ~= j then list[j], list[i] = list[i] end
      j = j + 1
    end
  end
  return v
end

function table:has(val)
  for i,v in next, self do
    if v == val then return true; end
  end
  return false
end

function math.round(x)
  return math.floor(x+0.5)
end

