local FElement = require("src.gui.FElement")

local function FRectangle(pX, pY, pW, pH)
    local rectangle = FElement(pX, pY)

    rectangle.w = pW
    rectangle.h = pH
    function rectangle:setDimension(pW, pH)
        rectangle.w = pW
        rectangle.h = pH
    end

    function rectangle:isHover(mx, my)
        return mx > self.x 
        and mx < self.x + self.w 
        and my > self.y 
        and my < self.y + self.h 
    end

    rectangle.showBorders = true
    rectangle.showBackground = false
    rectangle.rx = 2
    rectangle.ry = 2
    function rectangle:drawRectangle()
        love.graphics.push()
        if self.showBackground then
            love.graphics.rectangle("fill", self.x, self.y, self.w, self.h, self.rx, self.ry)
        end
        if self.showBorders then
            love.graphics.rectangle("line", self.x, self.y, self.w, self.h, self.rx, self.ry)
        end
        love.graphics.pop()
    end

    function rectangle:draw()
        self:drawRectangle()
    end
    
    return rectangle
end

return FRectangle