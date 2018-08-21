local gui = {}

local function Node(pX, pY)
    local node = {}

    node.x = pX
    node.y = pY
    function node:setPosition(pX, pY)
        self.x = pX
        self.y = pY
    end

    return node
end

function gui.Group(pX, pY)
    local group = Node(pX, pY)

    group.lstChildren = {}
    function group:append(pChild)
        table.insert(self.lstChildren, pChild)
    end

    function group:updateGroup(dt, mx, my, mousestate, keyboardstate)
        for _, child in pairs(self.lstChildren) do
            child:update(dt, mx - self.x, my - self.y, mousestate, keyboardstate)
        end
    end

    function group:update(dt, mx, my, mousestate, keyboardstate)
        self:updateGroup(dt, mx, my, mousestate, keyboardstate)
    end

    function group:drawGroup()
        love.graphics.push()
        love.graphics.translate(self.x, self.y)
        for _, child in pairs(self.lstChildren) do
            child:draw()
        end
        love.graphics.pop()
    end
    
    function group:draw()
        self:drawGroup()
    end

    return group
end

function gui.Element(pX, pY)
    local elt = Node(pX, pY)

    function elt:update(dt, mx, my, mousestate, keyboardstate)
    end

    function elt:draw()
    end

    return elt
end

function gui.Rectangle(pX, pY, pW, pH)
    local rectangle = gui.Element(pX, pY)

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

function gui.Label(pX, pY, pW, pH, pText)
    local label = gui.Rectangle(pX, pY, pW, pH)

    label.text = pText
    label.font = love.graphics.getFont()
    label.textw = label.font:getWidth(pText)
    label.texth = label.font:getHeight(pText)
    function label:setText(pText)
        self.text = pText
        self.textw = self.font:getWidth(pText)
        self.texth = self.font:getHeight(pText)
    end

    function label:drawLabel() 
        love.graphics.push()
        love.graphics.setFont(self.font)
        local x = self.x + (self.w - self.textw) / 2
        local y = self.y + (self.h - self.texth) / 2
        love.graphics.print(self.text, x, y)
        love.graphics.pop()
    end

    label.showBorders = false
    label.showBackground = false
    function label:draw()
        self:drawRectangle()
        self:drawLabel()
    end
    
    return label
end

function gui.Button(pX, pY, pW, pH, pText)
    local button = gui.Label(pX, pY, pW, pH, pText)

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

gui.root = gui.Group(0, 0)

gui.mousestate = {
    wasdown = false,
    isdown = false,
    ispressed = false,
    isreleased = false,
    isdoublepressed = false,
    doublepresstime = 0.3,
    doubletimer = 0,
    pressx = 0,
    pressy = 0,
}

gui.keyboardstate = {
    buffer = {},
    pressed = {},
}

love.keyboard.setKeyRepeat(true)

function gui:updateKeyboardstate()
    local ks = self.keyboardstate
    ks.pressed = {}
    for _, k in pairs(ks.buffer) do
        table.insert(ks.pressed, k)
    end
    ks.buffer = {}
end

function gui:keypressed(k)
    local ks = self.keyboardstate
    if k == "backspace"
    or k == "return"
    or k == "escape"
    then
        table.insert(ks.buffer, k)
    end
end

function gui:textinput(t)
    local ks = self.keyboardstate
    table.insert(ks.buffer, t)
end

function gui:updateMousestate(dt, mx, my)
    local mousedown = love.mouse.isDown(1)
    local ms = self.mousestate
    -- clear flags
    ms.ispressed = false
    ms.isdoublepressed = false
    ms.isreleased = false
    ms.isdown = mousedown

    -- compute state
    if mousedown and not ms.wasdown then
        ms.ispressed = true

        if ms.doubletimer <= 0 then
            -- single click
            ms.doubletimer = ms.doublepresstime
            ms.pressx = mx
            ms.pressy = my
        else
            -- double click
            local maxdelta = 5
            if mx >= ms.pressx - maxdelta 
            and mx <= ms.pressx + maxdelta
            and my >= ms.pressy - maxdelta 
            and my <= ms.pressy + maxdelta
            then
                ms.isdoublepressed = true
            end
        end
    elseif not mousedown and ms.wasdown then
        ms.isreleased = true
    end

    if ms.doubletimer > 0 then
        ms.doubletimer = ms.doubletimer - dt
    end

    -- keep track of old state
    ms.wasdown = mousedown

    --[[if ms.ispressed then
        if ms.isdoublepressed then
            print("double")
        else
            print("single")
        end
    elseif ms.isreleased then
        print("release")
    end]]
end

function gui:append(pChild)
    self.root:append(pChild)
end

function gui:update(dt, mx, my)
    self:updateKeyboardstate()
    self:updateMousestate(dt, mx, my)
    self.root:update(dt, mx, my, self.mousestate, self.keyboardstate)
end

function gui:draw()
    self.root:draw()
end

function love.keypressed(k)
    if k == "escape" then love.event.quit() end
    gui:keypressed(k)
end

function love.textinput(t)
    gui:textinput(t)
end

return gui