local FLabel = require("src.gui.FLabel")

function FButton(pX, pY, pW, pH, pText)
    local button = FButton(pX, pY, pW, pH, pText)

    button.isHover = false
    button.isPressed = false

    button.lstEvents = {}
    function button:addEvent(pEventType, pCallback)
        self.lstEvents[pEventType] = pCallback
    end

    function button:update(dt, mx, my, mousestate, keyboardstate)
        if mx > self.x and mx < self.x + self.w and my > self.y and my < self.y + self.h then
            if self.isHover == false then 
                self.isHover = true 
            end 
        else
            if self.isHover == true then 
                self.isHover = false 
            end 
        end

        if self.isHover then
            if mousestate.ispressed then
                button.isPressed = true
                if self.lstEvents["pressed"] ~= nil then
                    local event = self.lstEvents["pressed"]
                    event("begin")
                end
            elseif mousestate.isdown == false then
                button.isPressed = false
                if self.lstEvents["pressed"] ~= nil then
                    local event = self.lstEvents["pressed"]
                    event("end")
                end
            end
        else
            button.isPressed = false
        end
    end

    button.showBorders = true
    function button:draw()
        love.graphics.push()
        self:drawRectangle()
        if self.isPressed then
            love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
        elseif self.isHover then
            love.graphics.rectangle("line", self.x+2, self.y+2, self.w-4, self.h-4)
        end
        self:drawLabel()
        love.graphics.pop()
    end

    return button
end

return FButton