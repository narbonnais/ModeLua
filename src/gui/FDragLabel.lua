local FLabel = require("src.gui.FLabel")

local function FDragLabel(pX, pY, pW, pH, pText)
    local dragLabel = FLabel(pX, pY, pW, pH, pText)

    dragLabel.isDrag = false
    dragLabel.dragdx = 0
    dragLabel.dragdy = 0

    dragLabel.showBorders = true
    dragLabel.showBackground = true
    function dragLabel:update(dt, mx, my, mousestate, keyboardstate)
        if not self.visible then return end

        local relx = mx - self.x
        local rely = my - self.y
        
        if self:isHover(relx, rely) then
            if not self.isDrag and mousestate.ispressed then
                self.isDrag = true
                self.dragdx = relx
                self.dragdy = rely
            end
        end

        if self.isDrag then
            self.x = mx - self.dragdx
            self.y = my - self.dragdy

            if not mousestate.isdown then
                self.isDrag = false
            end
        end
    end
    
    return dragLabel
end

return FDragLabel