class_name StateMachine extends RefCounted

var states : Array[ActorState]
var current_state : ActorState

func initialize(possible_states : Array[ActorState], start_state : CombatantStates.States):
	states = possible_states
	current_state = possible_states[start_state]

func change_state():
	pass

func physics_process(delta : float):
	var change : StateChange = current_state.physics_process(delta)
	var safety_breakout : int = 0
	while (change.next_state != CombatantStates.States.NO_CHANGE):
		current_state.exit()
		current_state = states[change.next_state]
		current_state.enter()
		change = current_state.physics_process(change.remaining_delta)

		safety_breakout += 1
		if (safety_breakout > 100):
			push_error("LOGIC FLAW: Changed states 100 times in one physics_process")
			break
