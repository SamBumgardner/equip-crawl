class_name EnemyIdle extends ActorState

func physics_process(delta : float) -> StateChange:
	# todo: use logic tree here to decide if a new action should begin.
	# for now, will just make them immediately start charging
	
	if (owner as Enemy).get_turn_direction_toward_player() != MoveEffect.LateralDirection.NONE:
		owner.set_current_action(Action_Turn.new(owner), delta)
	elif (owner as Enemy).get_distance_to_player() == Position.Ranges.LONG and !(owner._current_action is Action_MidrangeMove):
		owner.set_current_action(Action_MidrangeMove.new(owner), delta)
	elif (owner as Enemy).get_distance_to_player() == Position.Ranges.SHORT:
		owner.set_current_action(Action_SpearSweep.new(owner), delta)
	else:
		owner.set_current_action(Action_SpearThrust.new(owner), delta)
	
	state_change.next_state = CombatantStates.States.CHARGE
	state_change.remaining_delta = delta
	return state_change 
