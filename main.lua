local mainFont = love.graphics.newFont("Pyxel.ttf", 20)
love.graphics.setFont(mainFont)
love.graphics.setDefaultFilter("nearest")

local gui = require("gui")

local model = {}
model.lstClasses = {}
local classindex = 0

local screenw = love.graphics.getWidth()
local screenh = love.graphics.getHeight()


function model.Class(pClassName)
    local class = {}
    class.name = pClassName

    return class
end

function gui.Class(pX, pY, pClassName)
    local class = gui.Group(pX, pY)

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

    local classname = "class" .. classindex
    classindex = classindex + 1

    -- view
    local mx, my = love.mouse.getPosition()
    local dragdx = 0
    local dragdy = 0
    local vclass = gui.Class(mx - dragdx, my - dragdy, classname)
    vclass.isDrag = true
    vclass.dragdx = dragdx
    vclass.dragdy = dragdy
    gui:append(vclass)
    
    -- model
    local mclass = model.Class(classname)
    table.insert(model.lstClasses, mclass)
end

local function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

local function generateCode(pState)
    if pState ~= "begin" then return end

    for _, mclass in pairs(model.lstClasses) do
        local filename = "gen/" .. mclass.name .. ".lua"
        -- open file
        local file = io.open(filename, "w+")
        -- write content
        local classname = mclass.name
        local args = "arg1, arg2"
        file:write("local function " .. firstToUpper(classname) .. "(" .. args .. ")\n")
        file:write("\t" .. classname .. " = {}\n") -- TODO: if parent == nil then {} else parentclassname
        file:write("\t\n")
        file:write("\treturn " .. classname .. "\n")
        file:write("end\n")
        file:write("\n")
        file:write("return " .. firstToUpper(classname))
        -- close file
        io.close(file)
    end
end

function love.load()
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
    love.graphics.setFont(mainFont)
end