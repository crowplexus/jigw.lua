--- Utility containing functions and variables to work with colors
--- @class Color
local Color = {
  BLACK           = {0,0,0,1},
  WHITE           = {1,1,1,1},
  RED             = {1,0,0,1},
  GREEN           = {0,1,0,1},
  BLUE            = {0,0,1,1},
  YELLOW          = {1,1,0,1},
  ORANGE          = {1,128/255,0,1},
  CYAN            = {0,1,1,1},
  PINK            = {1,192/255,203/255,1},
  BROWN           = {139/255,69/255,19/255,1},
  MAGENTA         = {1,0,1,1},
  LAVENDER        = {230/255,230/255,250/255,1},
  INDIGO          = {75/255,0,130/255,1},
  GREEN_YELLOW    = {173/255,1,47/255,1},
  PALE_GREEN      = {152/255,251/255,152/255,1},
  GRAY            = {128/255,128/255,128/255,1},

  --- Returns a color table in RGBA, from 0 to 255
  --- @param r number Red Channel Value.
  --- @param g number Green Channel Value.
  --- @param b number Blue Channel Value.
  --- @param a number? Alpha Channel Value.
  rgb = function(r,g,b,a)
    if not a or type(a) ~= "number" then a = 255 end
    return {r/255,g/255,b/255,a/255}
  end,
  --- Returns a color table in RGBA, from 0 to 1
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
