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

    label.edited = false
    label.blinkTmr = 0.3
    label.blinkPeriod = 1
    label.blinckVisible = true
    function label:toggleBlinkVisible()
        self.blinckVisible = not self.blinckVisible 
    end

    function label:updateLabel(dt)
        if self.edited then
            self.blinkTmr = self.blinkTmr + dt
            if self.blinkTmr >= self.blinkPeriod then
                self.blinkTmr = 0
                self:toggleBlinkVisible()
            end
        end
    end

    function label:update(dt, mx, my, mousestate)
        self:updateLabel(dt)
    end

    function label:drawLabel() 
        love.graphics.push()
        love.graphics.setFont(self.font)
        local x = self.x + (self.w - self.textw) / 2
        local y = self.y + (self.h - self.texth) / 2
        love.graphics.print(self.text, x, y)
        if self.edited then
            if self.blinckVisible then
                love.graphics.line(
                    x + self.textw, y,
                    x + self.textw, y + self.texth)
            end
        end
        love.graphics.pop()
    end

    label.showBorders = false
    label.showBackground = false
    function label:draw()
        if not self.visible then return end 
        self:drawRectangle()
        self:drawLabel()
    end
    
    return label
end

return FLabel