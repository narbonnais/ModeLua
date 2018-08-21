local gui = require("src.gui")
local writer = require("src.writer")
local generator = require("src.generator")
local screenw = love.graphics.getWidth()
local screenh = love.graphics.getHeight()


local uid = 0
local function UID() uid = uid + 1; return uid end

local lstClasses = {}


function gui.Class(pX, pY, pClassName, uid)
    local class = gui.Group(pX, pY)

    -- model
    class.uid = uid
    class.lstArgs = {}
    class.lstPrivateMember = {}
    class.lstPublicMember = {}
    class.lstPrivateMethod = {}
    class.lstPublicMethod = {}
    function class:addMember(pMemberName, pIsPublic)
        if pIsPublic then
            table.insert(self.lstPublicMember, pMemberName)
        else
            table.insert(self.lstPrivateMember, pMemberName)
        end
    end
    function class:addMethod(pMethodName, pIsPublic)
        if pIsPublic then
            table.insert(self.lstPublicMethod, pMethodName)
        else
            table.insert(self.lstPrivateMethod, pMethodName)
        end
    end

    -- view
    class.w = 150
    class.h = 200

    class.bgRect = gui.Rectangle(0, 0, class.w, class.h)
    class.titleLabel = gui.Label(0, 0, class.w, 30, pClassName)
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
                    self.titleLabel:setText(string.sub(self.titleLabel.text, 1, #self.titleLabel.text - 1))
                else
                    self.titleLabel:setText(self.titleLabel.text .. k)
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

local function createClass(pState)
    if pState ~= "begin" then return end

    local classUID = UID()
    local classname = "class" .. classUID

    -- view
    local mx, my = love.mouse.getPosition()
    local dragdx = 0
    local dragdy = 0

    local class = gui.Class(mx - dragdx, my - dragdy, classname, classUID)
    class.isDrag = true
    class.dragdx = dragdx
    class.dragdy = dragdy
    gui:append(class)

    class:addMember("myPublicMember", true)
    class:addMember("myPrivateMember", false)
    class:addMethod("myPublicMethod", true)
    class:addMethod("myPrivateMethod", false)

    table.insert(lstClasses, class)
end

function generateBtnCallback(pState)
    if pState == "begin" then
        generator.generateCode(lstClasses)
    end
end

function love.load()
    love.graphics.setDefaultFilter("nearest")

    local mainFont = love.graphics.newFont("assets/Pyxel.ttf", 20)
    love.graphics.setFont(mainFont)

    local sideRect = gui.Rectangle(0, 0, 150, screenh)
    local menuLabel = gui.Label(0, 0, 150, 50, "Menu bar")
    local addClassBtn = gui.Button(20, 50, 110, 70, "Add class")
    addClassBtn:addEvent("pressed", createClass)
    local generateBtn = gui.Button(20, screenh - 90, 110, 70, "Generate")
    generateBtn:addEvent("pressed", generateCode)
    gui:append(sideRect)
    gui:append(menuLabel)
    gui:append(addClassBtn)
    gui:append(generateBtn)
end

function love.update(dt)
    local mx, my = love.mouse.getPosition()
    gui:update(dt, mx, my)
end

function love.draw()
    gui:draw()
end