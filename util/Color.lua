--- Utility containing functions and variables to work with Colors
--- @class Color
local Color = {
  BLACK           = function() return {0,0,0,1} end,
  WHITE           = function() return {1,1,1,1} end,
  RED             = function() return {1,0,0,1} end,
  GREEN           = function() return {0,1,0,1} end,
  BLUE            = function() return {0,0,1,1} end,
  YELLOW          = function() return {1,1,0,1} end,
  ORANGE          = function() return {1,128/255,0,1} end,
  CYAN            = function() return {0,1,1,1} end,
  PINK            = function() return {1,192/255,203/255,1} end,
  BROWN           = function() return {139/255,69/255,19/255,1} end,
  MAGENTA         = function() return {1,0,1,1} end,
  LAVENDER        = function() return {230/255,230/255,250/255,1} end,
  INDIGO          = function() return {75/255,0,130/255,1} end,
  GREEN_YELLOW    = function() return {173/255,1,47/255,1} end,
  PALE_GREEN      = function() return {152/255,251/255,152/255,1} end,
  GRAY            = function() return {128/255,128/255,128/255,1} end,

  --- Returns a Color table in RGBA, from 0 to 255
  --- @param r number Red Channel Value.
  --- @param g number Green Channel Value.
  --- @param b number Blue Channel Value.
  --- @param a number? Alpha Channel Value.
  rgb = function(r,g,b,a)
    if not a or type(a) ~= "number" then a = 255 end
    --return love.math.colorFromBytes(r,g,b,a)
    return {r/255,g/255,b/255,a/255}
  end,
  --- Returns a Color table in RGBA, from 0 to 1
  --- @param r number Red Channel Value.
  --- @param g number Green Channel Value.
  --- @param b number Blue Channel Value.
  --- @param a number? Alpha Channel Value.
  rgbLinear = function(r,g,b,a)
    if not a or type(a) ~= "number" then a = 1 end
    return {r,g,b,a}
  end,
}
return Color
