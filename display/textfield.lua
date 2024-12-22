
--- @class TextField
local TextField = Class("TextField")

--- Creates a new text field with the given text.
--- @param x? number     X position of the text field.
--- @param y? number     Y position of the text field.
--- @param text? string Text to display.
function TextField:init(x, y, text)
    self.text = text or ""                   --- @type string
    self.visible = true                      --- @type boolean
    self.font = nil                          --- @type love.Font
    self.position = Vec2(x, y)               --- @type Vec2
    self.color = { 1, 1, 1, 1 }              --- @type table<number>
    self.shear = Vec2(0, 0)                  --- @type Vec2
    self.fieldEnd = love.graphics.getWidth() --- @type number
    self.alignment = "left"                  --- @type "left"|"center"|"right"
    return self
end

--- Updates the text field.
--- @param _ number  The time passed since the last frame.
function TextField:update(_)
end

function TextField:draw()
    if #self.text ~= 0 or self.visible then
        love.graphics.push("all")
        if self.color then love.graphics.setColor(self.color) end
        if self.font then love.graphics.setFont(self.font) end
        love.graphics.shear(self.shear:unpack())
        love.graphics.printf(self.text, self.position.x, self.position.y, self.fieldEnd, self.alignment)
        if self.color then love.graphics.setColor(1, 1, 1, 1) end
        if self.font then love.graphics.setFont(LoveDefaults.font) end
        love.graphics.pop()
    end
end

function TextField:set_font(nvl)
    if not nvl then return end
    if self.font ~= nil then
        self.font:release()
        self.font = nil
    end
    self.font = nvl
end

return TextField
