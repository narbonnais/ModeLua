local FGroup = require("src.gui.FGroup")
local FLabel = require("src.gui.FLabel")
local FRectangle = require("src.gui.FRectangle")

local function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function FClass(pX, pY)
    local class = FGroup(pX, pY)

    -- model
    class.uid = require("src.uid")()
    class.name = "class" .. class.uid
    class.lstArgs = {}
    class.lstAttributes = {}
    class.lstMethods = {}
    function class:addAttribute(pAttributeName)
        table.insert(self.lstAttributes, pAttributeName)
    end
    function class:addMethod(pMethodName)
        table.insert(self.lstMethods, pMethodName)
    end

    -- view
    class.w = 150
    class.h = 200

    class.bgRect = gui.Rectangle(0, 0, class.w, class.h)
    class.titleLabel = gui.Label(0, 0, class.w, 30, firstToUpper(class.name))
    function class:changeName(pName)
        self.name = pName
        self.titleLabel.text = firstToUpper(pName)
    end
    class:append(class.bgRect)
    class:append(class.titleLabel)

    class.isDrag = false
    class.dragdx = 0
    class.dragdy = 0

    class.changeTitle = false

    function class:update(dt, mx, my, mousestate, keyboardstate)
        local relx = mx - self.x
        local rely = my - self.y
        self:updateGroup(dt, relx, rely, mousestate, keyboardstate)

        -- change title
        if self.titleLabel:isHover(relx, rely) then
            if mousestate.isdoublepressed then
                self.changeTitle = true
                self.titleLabel.showBorders = true
            end
        else
            if mousestate.ispressed then
                self.changeTitle = false
                self.titleLabel.showBorders = false
            end
        end

        if self.changeTitle then
            for i = 1, #keyboardstate.pressed do
                local k = keyboardstate.pressed[i]
                if k == "escape" then
                    self.changeTitle = false
                    self.titleLabel.showBorders = false
                elseif k == "return" then
                    self.changeTitle = false
                    self.titleLabel.showBorders = false
                elseif k == "backspace" then
                    self:changeName(string.sub(self.titleLabel.text, 1, #self.titleLabel.text - 1))
                else
                    self:changeName(self.titleLabel.text .. k)
                end
            end
        end

        -- drag
        if self.bgRect:isHover(relx, rely) then
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

    return class
end

return FClass