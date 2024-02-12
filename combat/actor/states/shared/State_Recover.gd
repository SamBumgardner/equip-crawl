class_name State_Recover extends ActorState

var time_remaining : float

func physics_process(delta : float) -> StateChange:
	if (time_remaining <= delta):
		state_change.next_state = CombatantStates.States.IDLE
		state_change.remaining_delta = delta - time_remaining
		return state_change
	else:
		time_remaining -= delta
		state_change.next_state = CombatantStates.States.NO_CHANGE
		state_change.remaining_delta = 0
		return state_change

func enter():
	time_remaining = owner.current_action.recovery_time
	print(owner, " is now in recovery for ", owner.current_action.recovery_time, " seconds")
