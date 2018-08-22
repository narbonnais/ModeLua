local function FTransition(from, event, to)
    local transition = {}

    transition.from = from
    transition.event = event
    transition.to = to

    return transition
end

return FTransition