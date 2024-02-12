class_name State_Charge extends ActorState

func physics_process(delta : float) -> StateChange:
	if (time_remaining <= delta):
		state_change.next_state = CombatantStates.States.ACT
		state_change.remaining_delta = delta - time_remaining
		return state_change
	else:
		time_remaining -= delta
		state_change.next_state = CombatantStates.States.NO_CHANGE
		state_change.remaining_delta = 0
		return state_change

func enter():
	time_remaining = owner.current_action.charge_time
	print(owner, " is now charging for ", owner.current_action.charge_time, " seconds")
