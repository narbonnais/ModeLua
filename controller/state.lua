local function onEnter(params)
end

local function onExit(params)
end

local function State()
    local state = {}

    state.onEnter = onEnter
    state.onExit = onExit

    return state
end

return State