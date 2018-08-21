local mainFont = love.graphics.newFont("Pyxel.ttf", 20)
love.graphics.setFont(mainFont)
love.graphics.setDefaultFilter("nearest")

local gui = require("gui")

local uid = 0
local function UID()
    uid = uid + 1
    return uid
end

lstClasses = {}

local screenw = love.graphics.getWidth()
local screenh = love.graphics.getHeight()

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

local function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

local writer = {}
writer.file = nil
writer.indents = 0
function writer:indent()
    self.indents = self.indents + 1
end
function writer:outdent()
    self.indents = self.indents - 1
    if self.indents < 0 then
        self.indents = 0
    end
end
function writer:open(pFilename)
    if self.file ~= nil then
        self.file:close()
        self.file = nil
    end
    self.file = io.open(pFilename, "w")
end
function writer:line(pLine)
    local line = ""
    for i = 0, self.indents - 1 do
        line = line .. "\t"
    end
    line = line .. pLine
    line = line .. "\n"
    if self.file ~= nil then
        self.file:write(line)
    end
end
function writer:close()
    if self.file ~= nil then
        self.file:close()
        self.file = nil
    end
end

local function generateArgs(pLstArgs)
    local args = ""
    for i = 1, #pLstArgs do
        local arg = pLstArgs[i]
        args = args .. " " .. arg
        if i < #pLstArgs then
            args = args .. ","
        end
    end
    return args
end

local function removeFiles()
    local lfs = require "lfs";
 
    local doc_dir = system.DocumentsDirectory .. "/gen";
    local doc_path = system.pathForFile("", doc_dir);
    local resultOK, errorMsg;
    
    for file in lfs.dir(doc_path) do
        local theFile = system.pathForFile(file, doc_dir);
    
        if (lfs.attributes(theFile, "mode") ~= "directory") then
            resultOK, errorMsg = os.remove(theFile);
    
            if (resultOK) then
                print(file.." removed");
            else
                print("Error removing file: "..file..":"..errorMsg);
            end
        end
    end 
end

local function generateCode(pState)
    if pState ~= "begin" then return end

    for _, class in pairs(lstClasses) do
        local classname = class.titleLabel.text
        local filename = "gen/" .. classname .. ".lua"
        -- open file
        writer:open(filename)
        -- write content
        writer:line("-- private attributes")
        for i = 1, #class.lstPrivateMember do
            local member = class.lstPrivateMember[i]
            writer:line("local " .. member)
        end
        writer:line("")
        writer:line("-- private methods")
        for i = 1, #class.lstPrivateMethod do
            local methodname = class.lstPrivateMethod[i]
            local methodargs = {} -- TODO: give this function arguments
            local args = generateArgs(methodargs)
            writer:line("local function " .. methodname .. "(" .. args .. ")")
            writer:line("end")
        end
        writer:line("")
        local args = generateArgs(class.lstArgs)
        writer:line("local function " .. firstToUpper(classname) .. "(" .. args .. ")")
        writer:indent()
        writer:line("local " .. classname .. " = {}") -- TODO: if parent == nil then {} else parentclassname
        writer:line("")
        writer:line("-- public attributes")
        for i = 1, #class.lstPublicMember do
            local member = class.lstPublicMember[i]
            writer:line(classname .. "." .. member)
        end
        writer:line("")
        writer:line("-- public methods")
        for i = 1, #class.lstPublicMethod do
            local methodname = class.lstPublicMethod[i]
            local methodargs = {} -- TODO: give this function arguments
            local args = generateArgs(methodargs)
            writer:line("function " .. classname .. ":" .. methodname .. "(" .. args .. ")")
            writer:line("end")
        end
        writer:line("")
        writer:line("return " .. classname)
        writer:outdent()
        writer:line("end")
        writer:line("")
        writer:line("return " .. firstToUpper(classname))
        -- close file
        writer:close()
    end

    print("Code generated")
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