local FRectGroup = require("src.gui.FRectGroup")

local function FCanvas(pX, pY, pW, pH)
    local canvas = FRectGroup(pX, pY, pW, pH)

    canvas.lstClasses = {}
    function canvas:addClass(pClass)
        table.insert(self.lstClasses, pClass)
        self:append(pClass)
    end
    function canvas:isAnyClassHover(mx, my)
        local relx = mx - self.x
        local rely = my - self.y
        for _, class in pairs(self.lstClasses) do
            if class:isHover(relx, rely) then 
                return true 
            end
        end
        return false
    end

    return canvas
end

return FCanvas