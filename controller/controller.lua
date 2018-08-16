-- states
local EStates = require 'controller.enumstates'
local EEvents = require 'controller.enumevents'
local StateInitial = require 'controller.stateinitial'
local StateNewProject = require 'controller.statenewproject'
local Transition = require 'controller.transition'
-- ui
local Node = require 'view.node'
local Panel = require 'view.panel'
local Button = require 'view.button'
local Label = require 'view.label'
-- utils
local Callback = require 'utils.callback'

local SCREEN_W = love.graphics.getWidth()
local SCREEN_H = love.graphics.getHeight()

local function update(self, dt)
    self.rootNode:update(dt)
end

local function draw(self)
    self.rootNode:draw()
end

local function mousepressed(self, x, y, b)
    self.rootNode:onClick(x, y)
end

local function keypressed(self, k)
    if k == 'escape' then
        love.event.quit()
    end
end

local function doTransition(self, event)
    for i = 1, #self.transitions do
        local transition = self.transitions[i]
        if transition.originState == self.currentState and transition.triggerEvent == event then
            print("Changing state from " .. self.currentState .. " to " .. transition.destinationState)
            self.states[self.currentState]:onExit()
            self.currentState = transition.destinationState
            self.states[self.currentState]:onEnter()
            return
        end
    end
end

local function Controller()
    local c = {}

    -- love related
    c.update = update
    c.draw = draw
    c.mousepressed = mousepressed
    c.keypressed = keypressed

    -- states
    c.currentState = EStates.initial
    c.doTransition = doTransition

    c.states = {}
    c.states[EStates.initial] = StateInitial(c)
    c.states[EStates.newproject] = StateNewProject(c)

    c.transitions = {
        Transition(EStates.initial, EEvents.newproject, EStates.newproject),
        Transition(EStates.newproject, EEvents.backgroundclicked, EStates.initial),
        Transition(EStates.newproject, EEvents.newproject, EStates.initial),
    }

    -- ui
    c.rootNode = Node(0,0)
    c.menuPanel = Panel(0, 0, SCREEN_W, 60)
    c.newProjectButton = Button(10, 10, 40, 40, Callback(c, function(self) self:doTransition(EEvents.newproject) end, nil))
    local newProjectLabel = Label(0, 0, "NewProject")
    c.newProjectButton:append(newProjectLabel)
    c.menuPanel:append(c.newProjectButton)
    c.rootNode:append(c.menuPanel)

    c.newProjectPanel = Panel(SCREEN_W / 4, SCREEN_H / 4, SCREEN_W / 2, SCREEN_H / 2)
    c.newProjectPanel.visible = false
    c.rootNode:append(c.newProjectPanel)

    return c
end

return Controller