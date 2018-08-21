local FNode = require("src.gui.FNode")

local function FElement(pX, pY)
    local element = FNode(pX, pY)

    function element:update(dt, mx, my, mousestate, keyboardstate)
    end

    function element:draw()
        if not self.visible then return end
    end

    return element
end

return FElement