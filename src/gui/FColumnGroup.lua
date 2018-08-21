local FGroup = require("src.gui.FGroup") 
local FRectangle = require("src.gui.FRectangle") 

local function FColumGroup(pX, pY, pW, pH)
    local columnGroup = FGroup(pX, pY)
    columnGroup.w = pW
    columnGroup.h = pH
    columnGroup.minh = pH

    columnGroup.padding = 5

    columnGroup.bgRect = FRectangle(0, 0, pW, pH)
    columnGroup.bgRect.visible = false
    columnGroup:append(columnGroup.bgRect)

    columnGroup.items = {}
    function columnGroup:addItem(pItem)
        pItem.w = self.w - 2 * self.padding
        pItem.x = self.padding
        local y = self.padding
        for i, item in ipairs(self.items) do
            y = y + item.h + self.padding
        end
        pItem.y = y
        self.h = y + pItem.h + self.padding
        if self.h < self.minh then
            self.h = self.minh
        end
        self.bgRect:setDimension(self.w, self.h)
        self:append(pItem)
        table.insert(self.items, pItem)
    end


    return columnGroup
end

return FColumGroup