class_name OnionGreenIdle extends ActorState

var actions : Dictionary

var attack_phase : int = 0

func _init(owner_in : Combatant):
	super(owner_in)
	actions = {
		"turn": Action_Turn.new(owner, .1, .1),
		"retreat": Action_RangeMove.new(owner, Position.Ranges.LONG, .25, .25),
		"scallion_strike": Action_OnionScallionStrike.new(owner),
		"cool_down": Action_Stunned.new(1, "Cool Down"),
	}

func physics_process(delta : float) -> StateChange:
	if owner.unapplied_stun_duration > 0:
		owner.set_current_action(Action_Stunned.new(owner.unapplied_stun_duration))
		owner.unapplied_stun_duration = 0
		state_change.next_state = CombatantStates.States.ACT
		state_change.remaining_delta = delta
		return state_change
	
	if attack_phase == 0 and (owner as Enemy).get_turn_direction_toward_player() != MoveEffect.LateralDirection.NONE:
		owner.set_current_action(actions["turn"], delta)
	elif attack_phase == 0 and (owner as Enemy).get_distance_to_player() != Position.Ranges.LONG:
		owner.set_current_action(actions["retreat"], delta)
		attack_phase += 1
	elif attack_phase == 0:
		attack_phase += 1
	elif attack_phase == 1:
		actions["scallion_strike"].set_rate(1)
		owner.set_current_action(actions["scallion_strike"], delta)
		attack_phase += 1
	elif attack_phase == 2:
		actions["scallion_strike"].set_rate(.5)
		owner.set_current_action(actions["scallion_strike"], delta)
		attack_phase += 1
	elif attack_phase == 3:
		actions["scallion_strike"].set_rate(.3, true)
		owner.set_current_action(actions["scallion_strike"], delta)
		attack_phase += 1
	elif attack_phase == 4:
		owner.set_current_action(actions["cool_down"], delta)
		attack_phase += 1
	
	attack_phase = attack_phase % 5
	
	state_change.next_state = CombatantStates.States.CHARGE
	state_change.remaining_delta = delta
	return state_change 
