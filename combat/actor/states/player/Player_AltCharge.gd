class_name Player_AltCharge extends ActorState

func physics_process(delta : float) -> StateChange:
	if (Input.is_action_just_pressed("ui_left") and !(owner._current_action is Action_PlayerMoveLeft)):
		owner.set_current_action(Action_PlayerMoveLeft.new(), delta)
		state_change.next_state = CombatantStates.States.CHARGE
	if (Input.is_action_just_pressed("ui_right") and !(owner._current_action is Action_PlayerMoveRight)):
		owner.set_current_action(Action_PlayerMoveRight.new(), delta)
		state_change.next_state = CombatantStates.States.CHARGE
	if (Input.is_action_just_pressed("ui_up") and !(owner._current_action is Action_PlayerMoveForward)):
		owner.set_current_action(Action_PlayerMoveForward.new(), delta)
		state_change.next_state = CombatantStates.States.CHARGE
	if (Input.is_action_just_pressed("ui_down") and !(owner._current_action is Action_PlayerMoveBackward)):
		owner.set_current_action(Action_PlayerMoveBackward.new(), delta)
		state_change.next_state = CombatantStates.States.CHARGE
	
	if (Input.is_action_just_pressed("ui_accept") and !(owner._current_action is Action_PlayerAttack)):
		owner.set_current_action(Action_PlayerAttack.new(), delta)
		state_change.next_state = CombatantStates.States.CHARGE
	if (Input.is_action_just_pressed("ui_cancel") and !(owner._current_action is Action_PlayerPowerAttack)):
		owner.set_current_action(Action_PlayerPowerAttack.new(), delta)
		state_change.next_state = CombatantStates.States.CHARGE
	
	if (state_change.next_state == CombatantStates.States.NO_CHANGE):
		if (time_remaining <= delta):
			state_change.next_state = CombatantStates.States.ACT
			state_change.remaining_delta = delta - time_remaining
			
		else:
			time_remaining -= delta
			state_change.next_state = CombatantStates.States.NO_CHANGE
			state_change.remaining_delta = 0
	
	return state_change

func enter():
	state_change.next_state = CombatantStates.States.NO_CHANGE
	time_remaining = owner._current_action.charge_time
	owner.send_combat_effects(CombatantStates.States.CHARGE)
	print(owner, " is now charging for ", owner._current_action.charge_time, " seconds")
