class_name PlayerIdle extends ActorState

func physics_process(delta : float) -> StateChange:
	if owner.unapplied_stun_duration > 0:
		owner.set_current_action(Action_Stunned.new(owner.unapplied_stun_duration))
		owner.unapplied_stun_duration = 0
		state_change.next_state = CombatantStates.States.ACT
		state_change.remaining_delta = delta
		return state_change
	
	# todo: have input handling here to decide whether a new action should begin
	for input_mapping in Player.PLAYER_INPUTS.keys():
		if (Input.is_action_pressed(input_mapping)):
			var action = owner.get_available_action(Player.PLAYER_INPUTS[input_mapping])
			if action != null:
				owner.set_current_action(action, delta)
				state_change.next_state = CombatantStates.States.CHARGE
	
	#if (Input.is_action_pressed("direction_left")):
		#owner.set_current_action(Action_PlayerMoveLeft.new(), delta)
		#state_change.next_state = CombatantStates.States.CHARGE
	#if (Input.is_action_pressed("direction_right")):
		#owner.set_current_action(Action_PlayerMoveRight.new(), delta)
		#state_change.next_state = CombatantStates.States.CHARGE
	#if (Input.is_action_pressed("direction_up")):
		#owner.set_current_action(Action_PlayerMoveForward.new(), delta)
		#state_change.next_state = CombatantStates.States.CHARGE
	#if (Input.is_action_pressed("direction_down")):
		#owner.set_current_action(Action_PlayerMoveBackward.new(), delta)
		#state_change.next_state = CombatantStates.States.CHARGE
	#
	#if (Input.is_action_pressed("action_0_0")):
		#owner.set_current_action(Action_PlayerAttack.new(), delta)
		#state_change.next_state = CombatantStates.States.CHARGE
	#if (Input.is_action_pressed("action_0_1")):
		#owner.set_current_action(Action_PlayerPowerAttack.new(), delta)
		#state_change.next_state = CombatantStates.States.CHARGE

	return state_change 

func enter():
	state_change.next_state = CombatantStates.States.NO_CHANGE
