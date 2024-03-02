class_name OnionRedIdle extends ActorState

var actions : Dictionary

var attack_phase : int = 0

func _init(owner_in : Combatant):
	super(owner_in)
	actions = {
		"turn": Action_Turn.new(owner, .1, .1),
		"assault_short": Action_OnionLayeredAssault.new(owner, Position.Ranges.SHORT),
		"assault_medium": Action_OnionLayeredAssault.new(owner, Position.Ranges.MEDIUM, .75),
		"assault_long": Action_OnionLayeredAssault.new(owner, Position.Ranges.LONG, .5),
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
	elif attack_phase == 0:
		attack_phase += 1
	
	if attack_phase == 1:
		owner.set_current_action(actions["assault_short"], delta)
		attack_phase += 1
	elif attack_phase == 2:
		owner.set_current_action(actions["assault_medium"], delta)
		attack_phase = 0
	
	state_change.next_state = CombatantStates.States.CHARGE
	state_change.remaining_delta = delta
	return state_change 
