class_name OnionRedIdle extends ActorState

var actions : Dictionary

func _init(owner_in : Combatant):
	super(owner_in)
	actions = {
		#"turn": Action_Turn.new(owner),
		"move": Action_MidrangeMove.new(owner),
		"sweep": Action_SpearSweep.new(owner),
		"thrust": Action_SpearThrust.new(owner),
	}

func physics_process(delta : float) -> StateChange:
	if owner.unapplied_stun_duration > 0:
		owner.set_current_action(Action_Stunned.new(owner.unapplied_stun_duration))
		owner.unapplied_stun_duration = 0
		state_change.next_state = CombatantStates.States.ACT
		state_change.remaining_delta = delta
		return state_change
	# todo: use logic tree here to decide if a new action should begin.
	# for now, will just make them immediately start charging
	
	if (owner as Enemy).get_turn_direction_toward_player() != MoveEffect.LateralDirection.NONE:
		owner.set_current_action(actions["turn"], delta)
	elif (owner as Enemy).get_distance_to_player() == Position.Ranges.LONG and !(owner._current_action is Action_MidrangeMove):
		owner.set_current_action(actions["move"], delta)
	elif (owner as Enemy).get_distance_to_player() == Position.Ranges.SHORT:
		owner.set_current_action(Action_SpearSweep.new(owner), delta)
	else:
		owner.set_current_action(Action_SpearThrust.new(owner), delta)
	
	state_change.next_state = CombatantStates.States.CHARGE
	state_change.remaining_delta = delta
	return state_change 
