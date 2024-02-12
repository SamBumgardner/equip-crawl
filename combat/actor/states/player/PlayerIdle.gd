class_name PlayerIdle extends ActorState

func physics_process(delta : float) -> StateChange:
	# todo: have input handling here to decide whether a new action should begin
	if (Input.is_action_pressed("ui_left")):
		owner.current_action = Action_PlayerMoveLeft.new()
		state_change.next_state = CombatantStates.States.CHARGE
	if (Input.is_action_pressed("ui_right")):
		owner.current_action = Action_PlayerMoveRight.new()
		state_change.next_state = CombatantStates.States.CHARGE
	if (Input.is_action_pressed("ui_up")):
		owner.current_action = Action_PlayerMoveForward.new()
		state_change.next_state = CombatantStates.States.CHARGE
	if (Input.is_action_pressed("ui_down")):
		owner.current_action = Action_PlayerMoveBackward.new()
		state_change.next_state = CombatantStates.States.CHARGE
	
	if (Input.is_action_pressed("ui_select")):
		owner.current_action = Action_PlayerAttack.new()
		state_change.next_state = CombatantStates.States.CHARGE

	return state_change 

func enter():
	state_change.next_state = CombatantStates.States.NO_CHANGE
