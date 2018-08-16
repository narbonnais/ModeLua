local Node = require 'view.node'

local function draw(self)
    love.graphics.print(self.text, self.X, self.Y)
end

local function Label(x, y, text)
    local label = Node(x, y)

    label.text = text
    label.draw = draw

    return label
end

return Label