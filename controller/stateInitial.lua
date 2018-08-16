local State = require 'controller.state'

local function onEnter(self, params)
    local c = self.controller
end

local function onExit(self, params)
    local c = self.controller
end

local function StateInitial(controller)
    local state = State(controller)
    state.onEnter = onEnter
    state.onExit = onExit
    return state
end 

return StateInitial
