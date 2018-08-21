local FGroup = require("src.gui.FGroup")
local FLabel = require("src.gui.FLabel")
local FColumnGroup = require("src.gui.FColumnGroup") 
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

    -- view
    class.w = 150
    class.h = 200

    class.bgRect = FRectangle(0, 0, class.w, class.h)
    class.titleLabel = FLabel(0, 0, class.w, 30, firstToUpper(class.name))
    function class:changeName(pName)
        self.name = pName
        self.titleLabel:setText(firstToUpper(pName))
    end
    class:append(class.bgRect)
    class:append(class.titleLabel)

    class.isDrag = false
    class.dragdx = 0
    class.dragdy = 0

    class.changeTitle = false

    class.attributeGroup = FColumnGroup(5, class.titleLabel.h, class.w - 10, 80)
    class:append(class.attributeGroup)
    function class:toggleAttributeRegion()
        self.attributeGroup.bgRect.visible = not self.attributeGroup.bgRect.visible
    end

    class.methodGroup = FColumnGroup(5, class.attributeGroup.y + class.attributeGroup.h, class.w - 10, 80)
    class:append(class.methodGroup)
    function class:toggleFunctionRegion()
        self.methodGroup.bgRect.visible = not self.methodGroup.bgRect.visible
    end

    -- hovering
    function class:hoverAttributes(mx, my)
        return self.attributeGroup.bgRect:isHover(mx - self.attributeGroup.x, my - self.attributeGroup.y)
    end

    function class:hoverMethods(mx, my)
        return self.methodGroup.bgRect:isHover(mx - self.methodGroup.x, my - self.methodGroup.y)
    end

    -- model view
    class.lstAttributeLabels = {}
    class.lstMethodLabels = {}
    function class:refreshGroups()
        local y = 30
        local padding = 5
        local yfun = y + padding + self.attributeGroup.h
        self.methodGroup.y = yfun
        local h = yfun + self.methodGroup.h + padding
        self.h = h
        self.bgRect.h = h
    end
    function class:addAttribute(pAttributeName)
        local attributeName = pAttributeName or "attribute"..(#self.lstAttributes + 1)
        table.insert(self.lstAttributes, attributeName)

        local attributeLabel = FLabel(0, 0, 0, 20, attributeName)
        attributeLabel.showBorders = true
        self.attributeGroup:addItem(attributeLabel)
        self:refreshGroups()
    end
    function class:addMethod(pMethodName)
        local methodName = pMethodName or "method"..(#self.lstMethods + 1)
        table.insert(self.lstMethods, methodName)

        local methodLabel = FLabel(0, 0, 0, 20, methodName)
        methodLabel.showBorders = true
        self.methodGroup:addItem(methodLabel)
        self:refreshGroups()
    end

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