local FGroup = require("src.gui.FGroup")
local FRectangle = require("src.gui.FRectangle")

local function FRectGroup(pX, pY, pW, pH)
    local rectGroup = FGroup(pX, pY)
    rectGroup.w = pW
    rectGroup.h = pH

    rectGroup.bgRect = FRectangle(0, 0, pW, pH)
    --rectGroup:append(rectGroup.bgRect)
    function rectGroup:drawRect()
        love.graphics.push()
        love.graphics.translate(self.x, self.y)
        self.bgRect:draw()
        love.graphics.pop()
    end

    function rectGroup:draw()
        if self.visible == false then return end
        self:drawRect()
        self:drawGroup()
    end

    return rectGroup
end

return FRectGroup