class_name EnemyIdle extends ActorState

func physics_process(delta : float) -> StateChange:
	# todo: use logic tree here to decide if a new action should begin.
	# for now, will just make them immediately start charging
	
	if (owner as Enemy).get_turn_direction_toward_player() != MoveEffect.LateralDirection.NONE:
		owner.current_action = Action_Turn.new(owner)
	elif (owner as Enemy).get_distance_to_player() != Position.Ranges.MEDIUM and !(owner.current_action is Action_MidrangeMove):
		owner.current_action = Action_MidrangeMove.new(owner)
	else:
		owner.current_action = Action_SpearThrust.new(owner)
	
	state_change.next_state = CombatantStates.States.CHARGE
	state_change.remaining_delta = delta
	return state_change 
