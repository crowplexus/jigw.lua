return {
  --- @param x number number of bytes to format.
  --- @param digits? number number of digits on the returning string, defaults to 2.
  --- @return string
  formatBytes = function(x, digits)
      if digits == nil or type(digits) ~= "string" then
          digits = 2
      end
      local units = {"B", "KB", "MB", "GB", "TB", "PB"}
      local unit = 3
      while x >= 1024 and unit < #units do
          x = x / 1024
          unit = unit + 1
      end
      return string.format("%."..digits.."f", x)..units[unit]
  end,
  --- fake match/switch for lua
  match = function(prop, pat)
    if pat[prop] ~= nil then pat[prop]()
    elseif pat.default ~= nil then pat.default() end
  end,
    --- to draw text, that's it
  --- @param text string
  --- @param x number
  --- @param y number
  --- @param textColor? table<number>
  --- @param font? love.Font
  drawText = function(text,x,y,textColor,font)
    if not textColor then textColor = {1,1,1,1} end
    if not font then font = love.graphics.getFont() end
    if not x then x = 0 end
    if not y then y = 0 end
    local nf = type(font) == "string" and love.graphics.newFont(font, 32) or font
    local text = love.graphics.newText(nf,text)
    love.graphics.setColor(textColor)
    love.graphics.draw(text,x,y)
    love.graphics.setColor(1,1,1,1)
    -- free memory
    text:release()
    nf:release()
    text = nil
    nf = nil
  end,
  thousandSep = function(num, sep)
    if not num or type(num) ~= "number" then num = 0 end
    if not sep or type(sep) ~= "string" then sep = "," end
    local numStr = tostring(math.abs(num))
    local prefix = num < 0 and "-" or ""
    local modPos = 3
    if #numStr <= modPos then
      return prefix..numStr
    end
    local result = ""
    local digitPos = 0
    for i=#numStr,1,-1 do
      digitPos=digitPos+1
      result = string.sub(numStr,i,i)..result
      if digitPos % modPos == 0 and i > 1 then
        result = sep..result
      end
    end
    return prefix..result
  end,
  tablePrint = function(tbl, indent)
    if not indent then indent = 0 end
    local toprint = string.rep(" ", indent) .. "{\r\n"
    indent = indent + 2
    for k, v in pairs(tbl) do
      toprint = toprint .. string.rep(" ", indent)
      if (type(k) == "number") then
        toprint = toprint .. "[" .. k .. "] = "
      elseif (type(k) == "string") then
        toprint = toprint  .. k ..  "= "
      end
      if (type(v) == "number") then
        toprint = toprint .. v .. ",\r\n"
      elseif (type(v) == "string") then
        toprint = toprint .. "\"" .. v .. "\",\r\n"
      elseif (type(v) == "table") then
        toprint = toprint .. Utils.tablePrint(v, indent + 2) .. ",\r\n"
      else
        toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
      end
    end
    toprint = toprint .. string.rep(" ", indent-2) .. "}"
    return toprint
  end,

  wrap = function(num, min, max)
    if not min or type(min) ~= "number" then min = 1 end
    if not min or type(min) ~= "number" then max = 1 end
    return num < min and max or num > max and min or num
  end,
  clamp = function(num, min, max)
    if not min or type(min) ~= "number" then min = 1 end
    if not min or type(min) ~= "number" then max = 1 end
    return num < min and min or num > max and max or num
  end,
  calculateFramerate = function(time,since,framerate)
    return 1/framerate - (time - since)
  end
}
