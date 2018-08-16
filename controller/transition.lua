local function Transition(originState, triggerEvent, destinationState)
	local transition = {}
	transition.originState = originState
	transition.triggerEvent = triggerEvent
	transition.destinationState = destinationState
	return transition
end

return Transition