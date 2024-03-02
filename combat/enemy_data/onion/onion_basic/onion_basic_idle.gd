extends ActorState

var actions : Dictionary

func _init(owner_in : Combatant):
	super(owner_in)
	actions = {
		"turn": Action_Turn.new(owner, .2, .2),
		"advance": Action_RangeMove.new(owner, Position.Ranges.SHORT, .5, .5),
		"bonk": Action_OnionRollout.new(owner)
	}

func physics_process(delta : float) -> StateChange:
	if owner.unapplied_stun_duration > 0:
		owner.set_current_action(Action_Stunned.new(owner.unapplied_stun_duration))
		owner.unapplied_stun_duration = 0
		state_change.next_state = CombatantStates.States.ACT
		state_change.remaining_delta = delta
		return state_change
	
	if (owner as Enemy).get_turn_direction_toward_player() != MoveEffect.LateralDirection.NONE:
		owner.set_current_action(actions["turn"], delta)
	elif (owner as Enemy).get_distance_to_player() != Position.Ranges.SHORT:
		owner.set_current_action(actions["advance"], delta)
	else:
		owner.set_current_action(actions["bonk"], delta)
	
	state_change.next_state = CombatantStates.States.CHARGE
	state_change.remaining_delta = delta
	return state_change 
