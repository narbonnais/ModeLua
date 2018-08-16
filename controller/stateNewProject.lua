local State = require 'controller.state'

local function onEnter(params)

end

local function onExit(params)

end

local function StateNewProject(controller)
    local state = State(controller)
    state.onEnter = onEnter
    state.onExit = onExit
    return state
end 

return StateNewProject