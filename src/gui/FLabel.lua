local FRectangle = require("src.gui.FRectangle")

function FLabel(pX, pY, pW, pH, pText)
    local label = FRectangle(pX, pY, pW, pH)

    label.text = pText
    label.font = love.graphics.getFont()
    label.textw = label.font:getWidth(pText)
    label.texth = label.font:getHeight(pText)
    function label:setText(pText)
        self.text = pText
        self.textw = self.font:getWidth(pText)
        self.texth = self.font:getHeight(pText)
    end

    function label:drawLabel() 
        love.graphics.push()
        love.graphics.setFont(self.font)
        local x = self.x + (self.w - self.textw) / 2
        local y = self.y + (self.h - self.texth) / 2
        love.graphics.print(self.text, x, y)
        love.graphics.pop()
    end

    label.showBorders = false
    label.showBackground = false
    function label:draw()
        self:drawRectangle()
        self:drawLabel()
    end
    
    return label
end

return FLabel