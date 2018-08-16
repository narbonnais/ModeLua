local function onEnter(self, params)
end

local function onExit(self, params)
end

local function State(controller)
    local state = {}

    state.controller = controller
    state.onEnter = onEnter
    state.onExit = onExit

    return state
end

return State