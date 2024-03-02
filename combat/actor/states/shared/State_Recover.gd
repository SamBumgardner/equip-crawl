class_name State_Recover extends ActorState

func physics_process(delta : float) -> StateChange:
	if owner.unapplied_stun_duration > 0:
		owner.set_current_action(Action_Stunned.new(owner.unapplied_stun_duration))
		owner.unapplied_stun_duration = 0
		state_change.next_state = CombatantStates.States.ACT
		state_change.remaining_delta = delta
		return state_change
	
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
	time_remaining = owner._current_action.recovery_time
	owner.send_combat_effects(Action.ActionTriggers.RECOVERY_START)
	print(owner, " is now in recovery for ", owner._current_action.recovery_time, " seconds")

func exit():
	owner.send_combat_effects(Action.ActionTriggers.RECOVERY_END)
