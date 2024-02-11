class_name State_Act extends ActorState

func physics_process(delta : float) -> StateChange:
	state_change.next_state = CombatantStates.States.RECOVER
	state_change.remaining_delta = delta
	return state_change

func enter():
	print("combatant ", owner, " is now taking action ", owner.current_action)
	owner.send_current_act_effects()
