local FGroup = require("src.gui.FGroup")

local gui = {}

gui.root = FGroup(0, 0)
love.keyboard.setKeyRepeat(true)
gui.keyboardstate = {
    buffer = {},
    pressed = {},
    ctrl = false,
    shift = false,
    alt = false}
gui.mousestate = {
    wasdown = false,
    isdown = false,
    ispressed = false,
    isreleased = false,
    isdoublepressed = false,
    doublepresstime = 0.3,
    doubletimer = 0,
    pressx = 0,
    pressy = 0}

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
    if k == "escape" then love.event.quit()
    elseif k == "lctrl" then gui.keyboardstate.ctrl = true
    end
    gui:keypressed(k)
end

function love.keyreleased(k)
    if k == "lctrl" then
        gui.keyboardstate.ctrl = false
    end
end

function love.textinput(t)
    gui:textinput(t)
end

return gui