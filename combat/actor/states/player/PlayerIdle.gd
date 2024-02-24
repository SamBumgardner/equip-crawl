class_name PlayerIdle extends ActorState

func physics_process(delta : float) -> StateChange:
	# todo: have input handling here to decide whether a new action should begin
	if (Input.is_action_pressed("ui_left")):
		owner.set_current_action(Action_PlayerMoveLeft.new(), delta)
		state_change.next_state = CombatantStates.States.CHARGE
	if (Input.is_action_pressed("ui_right")):
		owner.set_current_action(Action_PlayerMoveRight.new(), delta)
		state_change.next_state = CombatantStates.States.CHARGE
	if (Input.is_action_pressed("ui_up")):
		owner.set_current_action(Action_PlayerMoveForward.new(), delta)
		state_change.next_state = CombatantStates.States.CHARGE
	if (Input.is_action_pressed("ui_down")):
		owner.set_current_action(Action_PlayerMoveBackward.new(), delta)
		state_change.next_state = CombatantStates.States.CHARGE
	
	if (Input.is_action_pressed("ui_accept")):
		owner.set_current_action(Action_PlayerAttack.new(), delta)
		state_change.next_state = CombatantStates.States.CHARGE
	if (Input.is_action_pressed("ui_cancel")):
		owner.set_current_action(Action_PlayerPowerAttack.new(), delta)
		state_change.next_state = CombatantStates.States.CHARGE

	return state_change 

func enter():
	state_change.next_state = CombatantStates.States.NO_CHANGE
