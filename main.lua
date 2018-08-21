local gui = require("src.gui.gui")
local generator = require("src.generator")
local uid = require("src.uid")

-- factories
local FClass = require ("src.FClass")
local FGroup = require ("src.gui.FGroup")
local FRectangle = require("src.gui.FRectangle")
local FButton = require("src.gui.FButton")
local FLabel = require("src.gui.FLabel")
local FDragLabel = require("src.gui.FDragLabel")

-- window dimension
local screenw = love.graphics.getWidth()
local screenh = love.graphics.getHeight()

-- scene params
local lstClasses = {}
local state = "default"
local selected = nil

local frontGroup
local midGroup
local backGroup

local addClassBtn
local addAttributeBtn
local addMethodBtn

local dragClassLabel

local function generateBtnCallback(pState)
    if pState == "begin" then
        generator.generateCode(lstClasses)
    end
end

local function addClass()
    local mx, my = love.mouse.getPosition()
    local class = FClass(mx, my)
    class:setPosition(class.x - class.w / 2, class.y - class.h / 2)

    --class:addAttribute("attribute1")
    --class:addMethod("method1")

    midGroup:append(class)
    table.insert(lstClasses, class)
end

local function addMethod()
    local mx, my = love.mouse.getPosition()
    for _, class in pairs(lstClasses) do
        if class:hoverMethods(mx - class.x, my - class.y) then
            class:addMethod()
            break
        end
    end
end

local function addAttribute()
    local mx, my = love.mouse.getPosition()
    for _, class in pairs(lstClasses) do
        if class:hoverAttributes(mx - class.x, my - class.y) then
            class:addAttribute()
            break
        end
    end
end

local function toggleAttributeRegions()
    for _, class in pairs(lstClasses) do
        class:toggleAttributeRegion()
    end
end

local function toggleFunctionRegions()
    for _, class in pairs(lstClasses) do
        class:toggleFunctionRegion()
    end
end

local function addClassCB(pState)
    if pState ~= "begin" then return end

    state = "dragClassLabel"
    dragClassLabel.x = addClassBtn.x
    dragClassLabel.y = addClassBtn.y
    local mx, my = love.mouse.getPosition()
    local dragdx = mx - dragClassLabel.x
    local dragdy = my - dragClassLabel.y
    dragClassLabel.isDrag = true
    dragClassLabel.dragdx = dragdx
    dragClassLabel.dragdy = dragdy
    dragClassLabel.visible = true
end

local function addMethodCB(pState)
    if pState ~= "begin" then return end

    state = "dragFunctionLabel"
    toggleFunctionRegions()
    dragFunctionLabel.x = addMethodBtn.x
    dragFunctionLabel.y = addMethodBtn.y
    local mx, my = love.mouse.getPosition()
    local dragdx = mx - dragFunctionLabel.x
    local dragdy = my - dragFunctionLabel.y
    dragFunctionLabel.isDrag = true
    dragFunctionLabel.dragdx = dragdx
    dragFunctionLabel.dragdy = dragdy
    dragFunctionLabel.visible = true
end 

local function addAttributeCB(pState)
    if pState ~= "begin" then return end

    state = "dragAttributeLabel"
    toggleAttributeRegions()
    dragAttributeLabel.x = addAttributeBtn.x
    dragAttributeLabel.y = addAttributeBtn.y
    local mx, my = love.mouse.getPosition()
    local dragdx = mx - dragAttributeLabel.x
    local dragdy = my - dragAttributeLabel.y
    dragAttributeLabel.isDrag = true
    dragAttributeLabel.dragdx = dragdx
    dragAttributeLabel.dragdy = dragdy
    dragAttributeLabel.visible = true
end 

function love.load()
    love.graphics.setDefaultFilter("nearest")

    -- create groups
    frontGroup = FGroup(0,0)
    midGroup = FGroup(0,0)
    backGroup = FGroup(0,0)
    gui:append(backGroup)
    gui:append(midGroup)
    gui:append(frontGroup)

    local mainFont = love.graphics.newFont("assets/Pyxel.ttf", 18)
    love.graphics.setFont(mainFont)

    local sideRect = FRectangle(0, 0, 180, screenh)
    backGroup:append(sideRect)

    local menuLabel = FLabel(0, 0, 180, 50, "Menu bar")
    backGroup:append(menuLabel)

    -- adders
    addClassBtn = FButton(20, 50, 140, 70, "Add Class")
    addClassBtn:addEvent("pressed", addClassCB)
    midGroup:append(addClassBtn)

    addAttributeBtn = FButton(20, 50 + 1 * 70 + 1 * 20, 140, 70, "Add Attribute")
    addAttributeBtn:addEvent("pressed", addAttributeCB)
    midGroup:append(addAttributeBtn)

    addMethodBtn = FButton(20, 50 + 2 * 70 + 2 * 20, 140, 70, "Add Function")
    addMethodBtn:addEvent("pressed", addMethodCB)
    midGroup:append(addMethodBtn)

    -- draggers
    dragClassLabel = FDragLabel(addClassBtn.x, addClassBtn.y, addClassBtn.w, addClassBtn.h, addClassBtn.text)
    dragClassLabel.visible = false
    frontGroup:append(dragClassLabel)

    dragFunctionLabel = FDragLabel(addMethodBtn.x, addMethodBtn.y, addMethodBtn.w, addMethodBtn.h, addMethodBtn.text)
    dragFunctionLabel.visible = false
    frontGroup:append(dragFunctionLabel)

    dragAttributeLabel = FDragLabel(addAttributeBtn.x, addAttributeBtn.y, addAttributeBtn.w, addAttributeBtn.h, addAttributeBtn.text)
    dragAttributeLabel.visible = false
    frontGroup:append(dragAttributeLabel)

    -- generate
    local generateBtn = FButton(20, screenh - 90, 140, 70, "Generate")
    generateBtn:addEvent("pressed", generateBtnCallback)
    midGroup:append(generateBtn)
end

function love.update(dt)
    local mx, my = love.mouse.getPosition()
    gui:update(dt, mx, my)

    if state == "dragClassLabel" then
        if gui.mousestate.isreleased then
            state = "default"
            dragClassLabel.visible = false
            addClass()
        end
    elseif state == "dragFunctionLabel" then
        if gui.mousestate.isreleased then
            state = "default"
            dragFunctionLabel.visible = false
            addMethod()
            toggleFunctionRegions()
        end
    elseif state == "dragAttributeLabel" then
        if gui.mousestate.isreleased then
            state = "default"
            dragAttributeLabel.visible = false
            addAttribute()
            toggleAttributeRegions()
        end
    end
end

function love.draw()
    gui:draw()
end