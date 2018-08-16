local State = require 'controller.state'

local function onEnter(self, params)
    local c = self.controller
    c.newProjectPanel.visible = true
end

local function onExit(self, params)
    local c = self.controller
    c.newProjectPanel.visible = false
end

local function StateNewProject(controller)
    local state = State(controller)
    state.onEnter = onEnter
    state.onExit = onExit
    return state
end 

return StateNewProject