class_name Player_AltCharge extends ActorState

func physics_process(delta : float) -> StateChange:
	if (Input.is_action_just_pressed("ui_left") and !(owner.current_action is Action_PlayerMoveLeft)):
		owner.current_action = Action_PlayerMoveLeft.new()
		state_change.next_state = CombatantStates.States.CHARGE
	if (Input.is_action_just_pressed("ui_right") and !(owner.current_action is Action_PlayerMoveRight)):
		owner.current_action = Action_PlayerMoveRight.new()
		state_change.next_state = CombatantStates.States.CHARGE
	if (Input.is_action_just_pressed("ui_up") and !(owner.current_action is Action_PlayerMoveForward)):
		owner.current_action = Action_PlayerMoveForward.new()
		state_change.next_state = CombatantStates.States.CHARGE
	if (Input.is_action_just_pressed("ui_down") and !(owner.current_action is Action_PlayerMoveBackward)):
		owner.current_action = Action_PlayerMoveBackward.new()
		state_change.next_state = CombatantStates.States.CHARGE
	
	if (Input.is_action_just_pressed("ui_accept") and !(owner.current_action is Action_PlayerAttack)):
		owner.current_action = Action_PlayerAttack.new()
		state_change.next_state = CombatantStates.States.CHARGE
	if (Input.is_action_just_pressed("ui_cancel") and !(owner.current_action is Action_PlayerPowerAttack)):
		owner.current_action = Action_PlayerPowerAttack.new()
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
	time_remaining = owner.current_action.charge_time
	print(owner, " is now charging for ", owner.current_action.charge_time, " seconds")
