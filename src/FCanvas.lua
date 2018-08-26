local FRectGroup = require("src.gui.FRectGroup")
local FClass = require("src.FClass")

local function FCanvas(pX, pY, pW, pH)
    local canvas = FRectGroup(pX, pY, pW, pH)

    canvas.dx = 0
    canvas.dy = 0

    canvas.lstClasses = {}
    function canvas:addClass(mx, my)
        local class = FClass(mx - self.x - self.dx, my - self.y - self.dy)
        class:setPosition(class.x - class.w / 2, class.y - class.h / 2)
        table.insert(self.lstClasses, class)
        self:append(class)
    end

    function canvas:addAttribute(mx, my)
        local x = mx - self.x - self.dx
        local y = my - self.y - self.dy
        for _, class in pairs(self.lstClasses) do
            if class:hoverAttributes(x , y) then
                class:addAttribute()
                break
            end
        end
    end

    function canvas:addMethod(mx, my)
        local x = mx - self.x - self.dx
        local y = my - self.y - self.dy
        for _, class in pairs(self.lstClasses) do
            if class:hoverMethods(x , y) then
                class:addMethod()
                break
            end
        end
    end

    function canvas:isAnyClassHover(mx, my)
        local relx = mx - self.x - self.dx
        local rely = my - self.y - self.dy
        for _, class in pairs(self.lstClasses) do
            if class:isHover(relx, rely) then 
                return true
            end
        end
        return false
    end

    canvas.rightwaspressed = false
    canvas.mx = 0
    canvas.my = 0
    function canvas:updateCanvas(dt, mx, my)
        local rightpressed = love.mouse.isDown(2)

        if rightpressed 
        and self.rightwaspressed
        then
            local dx = mx - self.mx
            local dy = my - self.my

            self.dx = self.dx + dx
            self.dy = self.dy + dy
        end

        self.mx = mx
        self.my = my
        self.rightwaspressed = rightpressed
    end

    function canvas:update(dt, mx, my, mousestate, keyboardstate)
        self:updateGroup(dt, mx - self.dx, my - self.dy, mousestate, keyboardstate)
        self:updateCanvas(dt, mx, my)
    end

    function canvas:draw()
        self:drawRect()
        love.graphics.push()
        love.graphics.translate(self.dx, self.dy)
        self:drawGroup()
        love.graphics.pop()
    end

    return canvas
end

return FCanvas