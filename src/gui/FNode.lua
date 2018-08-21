local function FNode(pX, pY)
    local node = {}

    node.x = pX
    node.y = pY
    function node:setPosition(pX, pY)
        self.x = pX
        self.y = pY
    end

    return node
end

return FNode