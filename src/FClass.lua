local FGroup = require("src.gui.FGroup")
local FLabel = require("src.gui.FLabel")
local FColumnGroup = require("src.gui.FColumnGroup") 
local FRectangle = require("src.gui.FRectangle")
local FTransition = require("src.FTransition")
local FState = require("src.FState")

local function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

--[[local states = {
    "default",
    "titleedit",
    "attributeedit",
    "methodedit"
}

local events = {
    "clickedout",
    "edittitle",
    "editattribute",
    "editmethod"
}]]

local function FDefaultState(pClass)
    local defaultState = FState()
    defaultState.class = pClass
    
    function defaultState:update(dt, mx, my, mousestate, keyboardstate)
        if mousestate.isdoublepressed then
            if self.class.titleLabel:isHover(mx, my) then
                self.class:doTranstition("edittitle", {title = self.class.titleLabel})
            else
                local attribute = self.class.attributeGroup:getHoveredItem(mx, my)
                if attribute ~= nil then
                    print(attribute.text)
                    self.class:doTranstition("editattribute", {attribute = attribute})
                else
                    local method = self.class.methodGroup:getHoveredItem(mx, my)
                    if method ~= nil then
                        print(method.text)
                        self.class:doTranstition("editmethod", {method = method})
                    end
                end
            end
        end
    end

    return defaultState
end

local function FTitleEditState(pClass)
    local titleEditState = FState()
    titleEditState.class = pClass
    titleEditState.title = nil

    function titleEditState:onEntry(pParams)
        self.title = pParams.title
        self.title.showBorders = true
        self.title.edited = true
    end

    function titleEditState:update(dt, mx, my, mousestate, keyboardstate)
        if mousestate.isdoublepressed then
            if self.class.attributeGroup:isHover(mx, my) and #self.class.attributeGroup.lstItems > 1 then
                self.class:doTranstition("editattribute", {attribute = self.class.attributeGroup.lstItems[1]})
            elseif self.class.methodGroup:isHover(mx, my) and #self.class.methodGroup.lstItems > 1 then
                self.class:doTranstition("editmethod", {method = self.class.methodGroup.lstItems[1]})
            end
        elseif mousestate.ispressed then
            self.class:doTranstition("clickedout")
        end

        -- TODO: give label own writing system
        for i = 1, #keyboardstate.pressed do
            local k = keyboardstate.pressed[i]

            if k == "escape" or  k == "return" then
                self.class:doTranstition("clickedout")
            elseif k == "backspace" then
                if keyboardstate.ctrl then
                    self.title:setText("")
                    self.class.name = ""
                else
                    self.title:setText(string.sub(self.title.text, 1, #self.title.text - 1))
                    self.class.name = self.title.text
                end
            else
                self.title:setText(self.title.text .. k)
                self.class.name = self.title.text
            end
        end
    end

    function titleEditState:onExit()
        self.title.showBorders = false
        self.title.edited = false
    end

    return titleEditState
end

local function FAttributeEditState(pClass)
    local attributeEditState = FState()
    attributeEditState.class = pClass
    attributeEditState.attribute = nil

    function attributeEditState:onEntry(pParams)
        self.attribute = pParams.attribute
        self.attribute.edited = true
    end

    function attributeEditState:update(dt, mx, my, mousestate, keyboardstate)
        if mousestate.isdoublepressed then
            if self.class.titleLabel:isHover(mx, my) then
                self.class:doTranstition("edittitle", {title = self.class.titleLabel})
            elseif self.class.methodGroup:isHover(mx, my) and #self.class.methodGroup.lstItems > 1 then
                self.class:doTranstition("editmethod", {method = self.class.methodGroup.lstItems[1]})
            end
        elseif mousestate.ispressed then
            self.class:doTranstition("clickedout")
        end

        for i = 1, #keyboardstate.pressed do
            local k = keyboardstate.pressed[i]

            if k == "escape" or  k == "return" then
                self.class:doTranstition("clickedout")
            elseif k == "backspace" then
                if keyboardstate.ctrl then
                    self.attribute:setText("")
                else
                    self.attribute:setText(string.sub(self.attribute.text, 1, #self.attribute.text - 1))
                end
            else
                self.attribute:setText(self.attribute.text .. k)
            end
        end
    end

    function attributeEditState:onExit()
        self.attribute.edited = false
    end

    return attributeEditState
end

local function FMethodEditState(pClass)
    local methodEditState = FState()
    methodEditState.class = pClass
    methodEditState.method = nil
    

    function methodEditState:onEntry(pParams)
        self.method = pParams.method
        self.method.edited = true
    end

    function methodEditState:update(dt, mx, my, mousestate, keyboardstate)
        if mousestate.isdoublepressed then
            if self.class.titleLabel:isHover(mx, my) then
                self.class:doTranstition("edittitle", {title = self.class.titleLabel})
            elseif self.class.attributeGroup:isHover(mx, my) and #self.class.attributeGroup.lstItems > 1 then
                self.class:doTranstition("editattribute", {attribute = self.class.attributeGroup.lstItems[1]})
            end
        elseif mousestate.ispressed then
            self.class:doTranstition("clickedout")
        end

        for i = 1, #keyboardstate.pressed do
            local k = keyboardstate.pressed[i]

            if k == "escape" or  k == "return" then
                self.class:doTranstition("clickedout")
            elseif k == "backspace" then
                if keyboardstate.ctrl then
                    self.method:setText("")
                else
                    self.method:setText(string.sub(self.method.text, 1, #self.method.text - 1))
                end
            else
                self.method:setText(self.method.text .. k)
            end
        end
    end

    function methodEditState:onExit()
        self.method.edited = false
    end

    return methodEditState
end

local transitions = {
    FTransition("default", "edittitle", "titleedit"),
    FTransition("default", "editattribute", "attributeedit"),
    FTransition("default", "editmethod", "methodedit"),

    FTransition("titleedit", "clickedout", "default"),
    FTransition("titleedit", "editattribute", "attributeedit"),
    FTransition("titleedit", "editmethod", "methodedit"),

    FTransition("attributeedit", "edittitle", "titleedit"),
    FTransition("attributeedit", "clickedout", "default"),
    FTransition("attributeedit", "editmethod", "methodedit"),

    FTransition("methodedit", "edittitle", "titleedit"),
    FTransition("methodedit", "editattribute", "attributeedit"),
    FTransition("methodedit", "clickedout", "default"),
}

function FClass(pX, pY)
    local class = FGroup(pX, pY)

    -- model
    class.uid = require("src.uid")()
    class.name = "class" .. class.uid
    class.lstArgs = {}
    
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
        return self.attributeGroup.bgRect:isHover(mx - self.x - self.attributeGroup.x, my - self.y - self.attributeGroup.y)
    end

    function class:hoverMethods(mx, my)
        return self.methodGroup.bgRect:isHover(mx - self.x - self.methodGroup.x, my - self.y - self.methodGroup.y)
    end

    function class:isHover(mx, my)
        return self.bgRect:isHover(mx - self.x, my - self.y)
    end

    -- model view
    class.lstAttributeLabels = {}
    class.lstMethodLabels = {}

    class.isDrag = false
    class.dragdx = 0
    class.dragdy = 0

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
        local attributeName = pAttributeName or "attribute"..(#self.attributeGroup.lstItems + 1)

        local attributeLabel = FLabel(0, 0, 0, 20, attributeName)
        attributeLabel.showBorders = true
        self.attributeGroup:addItem(attributeLabel)
        self:refreshGroups()
    end
    function class:addMethod(pMethodName)
        local methodName = pMethodName or "method"..(#self.methodGroup.lstItems + 1)

        local methodLabel = FLabel(0, 0, 0, 20, methodName)
        methodLabel.showBorders = true
        self.methodGroup:addItem(methodLabel)
        self:refreshGroups()
    end

    class.currentStateName = "default"
    class.states = {
        ["default"]         = FDefaultState(class),
        ["titleedit"]       = FTitleEditState(class),
        ["attributeedit"]   = FAttributeEditState(class),
        ["methodedit"]      = FMethodEditState(class)
    }
    class.currentState = class.states[class.currentStateName]

    function class:doTranstition(pEvent, pParams)
        for _, transition in pairs(transitions) do
            if transition.from == self.currentStateName and transition.event == pEvent then
                --print("Transition from " .. transition.from .. " to " .. transition.to .. " with event " .. pEvent)
                self.currentState:onExit(pParams)
                self.currentStateName = transition.to
                self.currentState = self.states[self.currentStateName]
                self.currentState:onEntry(pParams)
                return
            end
        end

        --print("No transition found with event : " .. pEvent)
    end

    function class:updateClass(dt, mx, my, mousestate, keyboardstate)
        local relx = mx - self.x
        local rely = my - self.y

        self.currentState:update(dt, relx, rely, mousestate, keyboardstate)
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

    function class:update(dt, mx, my, mousestate, keyboardstate)
        self:updateGroup(dt, mx, my, mousestate, keyboardstate)
        self:updateClass(dt, mx, my, mousestate, keyboardstate)
    end

    return class
end

return FClass