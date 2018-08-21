local gui = require("src.gui")
local generator = require("src.generator")
local Class = require ("src.Class")

local screenw = love.graphics.getWidth()
local screenh = love.graphics.getHeight()

local lstClasses = {}
local state = "default"
local selected = nil

local function createBtnCallback(pState)
    if pState ~= "begin" then return end

    -- view
    local mx, my = love.mouse.getPosition()
    local dragdx = 0
    local dragdy = 0

    local class = Class(mx - dragdx, my - dragdy)
    class.isDrag = true
    class.dragdx = dragdx
    class.dragdy = dragdy
    gui:append(class)

    class:addAttribute("attribute1")
    class:addAttribute("attribute2")
    class:addMethod("method1")
    class:addMethod("methode2")

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
    addClassBtn:addEvent("pressed", createBtnCallback)
    local generateBtn = gui.Button(20, screenh - 90, 110, 70, "Generate")
    generateBtn:addEvent("pressed", generateBtnCallback)
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