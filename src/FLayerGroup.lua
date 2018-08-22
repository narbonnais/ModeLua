local FGroup = require("src.gui.FGroup")

local function FLayerGroup(pX, pY)
    local layerGroup = FGroup(pX, pY)
    layerGroup.w = pW
    layerGroup.h = pH

    layerGroup.back = FGroup(0,0)
    layerGroup.mid = FGroup(0,0)
    layerGroup.front = FGroup(0,0)

    -- append back to front
    layerGroup:append(layerGroup.back)
    layerGroup:append(layerGroup.mid)
    layerGroup:append(layerGroup.front)

    return layerGroup
end

return FLayerGroup