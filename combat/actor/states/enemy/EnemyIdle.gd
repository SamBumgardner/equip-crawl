class_name EnemyIdle extends ActorState

func physics_process(delta : float) -> StateChange:
	# todo: use logic tree here to decide if a new action should begin.
	# for now, will just make them immediately start charging
	state_change.next_state = CombatantStates.States.CHARGE
	state_change.remaining_delta = delta
	return state_change 
