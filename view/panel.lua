local Node = require 'view.node'
local Color = require 'utils.color'

local function draw(self)
    if self.isVisible == false then return end

    local x = self.X
    local y = self.Y
    local w = self.w
    local h = self.h

    -- draw background
    love.graphics.setColor(self.backgroundColor)
    love.graphics.rectangle('fill', x, y, w, h)

    -- draw children
    self:drawChildren()

    -- draw bounds
    if self.areBoundsVisible == true then
        love.graphics.setColor(self.boundsColor)
        love.graphics.rectangle('line', x, y, w, h)
    end
end

local function Panel(x, y, w, h)
    local panel = Node(x, y)

    -- dimensions
    panel.w = w
    panel.h = h

    -- display
    panel.isVisible = true
    panel.backgroundColor = Color(1,1,1,1)
    panel.areBoundsVisible = true
    panel.boundsColor = Color(0,0,0,1)
    panel.draw = draw

    return panel
end

return Panel