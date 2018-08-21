local FNode = require("src.gui.FNode")

local function FGroup(pX, pY)
    local group = FNode(pX, pY)

    group.lstChildren = {}
    function group:append(pChild)
        table.insert(self.lstChildren, pChild)
    end

    function group:updateGroup(dt, mx, my, mousestate, keyboardstate)
        for _, child in pairs(self.lstChildren) do
            child:update(dt, mx - self.x, my - self.y, mousestate, keyboardstate)
        end
    end

    function group:update(dt, mx, my, mousestate, keyboardstate)
        self:updateGroup(dt, mx, my, mousestate, keyboardstate)
    end

    function group:drawGroup()
        love.graphics.push()
        love.graphics.translate(self.x, self.y)
        for _, child in pairs(self.lstChildren) do
            child:draw()
        end
        love.graphics.pop()
    end
    
    function group:draw()
        if not self.visible then return end
        self:drawGroup()
    end

    return group
end

return FGroup