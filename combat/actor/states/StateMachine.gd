class_name StateMachine extends RefCounted

var owner : Combatant
var states : Array[ActorState]
var current_state : ActorState

func initialize(owner_in : Combatant, possible_states : Array[ActorState], 
		start_state : CombatantStates.States):
	owner = owner_in
	states = possible_states
	current_state = possible_states[start_state]

func change_state():
	pass

func physics_process(delta : float):
	var change : StateChange = current_state.physics_process(delta)
	var safety_breakout : int = 0
	while (change.next_state != CombatantStates.States.NO_CHANGE):
		current_state.exit()
		var newly_selected_state = change.next_state
		current_state = states[change.next_state]
		current_state.enter()
		change = current_state.physics_process(change.remaining_delta)
		
		owner.state_changed.emit(newly_selected_state, current_state.time_remaining,
			owner.current_action)

		safety_breakout += 1
		if (safety_breakout > 100):
			push_error("LOGIC FLAW: Changed states 100 times in one physics_process")
			break
