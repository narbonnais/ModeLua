local Node = require 'view.node'
local Color = require 'utils.color'

local function draw(self)
    if self.visible == false then return end

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
    if self.boundsVisible == true then
        love.graphics.setColor(self.boundsColor)
        love.graphics.rectangle('line', x, y, w, h)
    end
end

local function setBackgroundColor(self, r, g, b, a)
    self.backgroundColor = Color(r,g,b,a)
end

local function setBoundsColor(self, r, g, b, a)
    self.boundsColor = Color(r,g,b,a)
end

local function hovered(self, x, y)
    return not (x < self.X or x > self.X + self.w or y < self.Y or y > self.Y + self.h)
end

local function onClick(self, x, y)
    if self.visible == false then return false end

    local clicked = self:hovered(x, y)
    if clicked then
        -- watch children only if panel was clicked (they should be inside panel)
        local childrenClicked = self:onChildrenClick(x, y)

        -- panel was clicked
        return true
    end
    -- panel wasn't clicked
    return false
end

local function Panel(x, y, w, h)
    local panel = Node(x, y)

    -- dimensions
    panel.w = w
    panel.h = h

    -- display
    panel.visible = true
    panel.backgroundColor = Color(1,1,1,1)
    panel.boundsVisible = true
    panel.boundsColor = Color(0,0,0,1)
    panel.draw = draw
    panel.setBackgroundColor = setBackgroundColor
    panel.setBoundsColor = setBoundsColor

    -- action
    panel.hovered = hovered
    panel.onClick = onClick
    return panel
end

return Panel