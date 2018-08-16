local Panel = require 'view.panel'
local Label = require 'view.label'

local function draw(self)
    if self.visible == false then return end

    local text = self.placeholder
    if self.input ~= "" then
        text = self.input
    end

    local x = self.X
    local y = self.Y
    local w = self.w
    local h = self.h

    -- draw background
    love.graphics.setColor(self.backgroundColor)
    love.graphics.rectangle('fill', x, y, w, h)

    -- draw bounds
    love.graphics.setColor(self.boundsColor)
    if self.boundsVisible == true then
        love.graphics.rectangle('line', x, y, w, h)
    end
    
    love.graphics.print(text, self.X, self.Y)
end

local function Textfield(x, y, w, h)
    local tf = Panel(x, y, w, h)

    tf.placeholder = "i hold"
    tf.input = ""

    tf.draw = draw
    return tf
end

return Textfield