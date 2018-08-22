local FGroup = require("src.gui.FGroup")
local FRectangle = require("src.gui.FRectangle")

local function FRectGroup(pX, pY, pW, pH)
    local rectGroup = FGroup(pX, pY)
    rectGroup.w = pW
    rectGroup.h = pH

    rectGroup.bgRect = FRectangle(0, 0, pW, pH)
    rectGroup:append(rectGroup.bgRect)

    return rectGroup
end

return FRectGroup