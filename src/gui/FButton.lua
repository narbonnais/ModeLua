local FLabel = require("src.gui.FLabel")

function FButton(pX, pY, pW, pH, pText)
    local button = FLabel(pX, pY, pW, pH, pText)

    button.hovered = false
    button.pressed = false

    button.lstEvents = {}
    function button:addEvent(pEventType, pCallback)
        self.lstEvents[pEventType] = pCallback
    end

    function button:update(dt, mx, my, mousestate, keyboardstate)
        self.hovered = self:isHover(mx, my)

        if self.hovered then
            if mousestate.ispressed then
                button.pressed = true
                if self.lstEvents["pressed"] ~= nil then
                    local event = self.lstEvents["pressed"]
                    event("begin")
                end
            elseif button.pressed == true
            and mousestate.isdown == false then
                button.pressed = false
                if self.lstEvents["pressed"] ~= nil then
                    local event = self.lstEvents["pressed"]
                    event("end")
                end
            end
        else
            button.pressed = false
        end
    end

    button.showBorders = true
    button.showBackground = true
    function button:draw()
        if not self.visible then return end
        love.graphics.push()
        self:drawRectangle()
        if self.pressed then
            love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
        elseif self.hovered then
            love.graphics.rectangle("line", self.x+2, self.y+2, self.w-4, self.h-4)
        end
        self:drawLabel()
        love.graphics.pop()
    end

    return button
end

return FButton