class_name Enemy extends Combatant

signal enemy_turn(direction : Position.Direction)
signal threat_warning_new(
	threatened_positions : Array[Vector2i], 
	time_until_triggered : float, 
	triggering_action : Action)
signal threat_warning_cancel(canceled_action : Action)

var facing : Position.Direction = Position.Direction.SOUTH

func _init():
	possible_states = [
		EnemyIdle.new(self),
		State_Charge.new(self),
		State_Act.new(self),
		State_Recover.new(self),
	]
	hurt_visual_effect = VisualEffect.new("enemy_hurt")
	block_visual_effect = VisualEffect.new("enemy_block")
	set_current_action(Action_SpearThrust.new(self))

func _to_string():
	return "Enemy"

func _is_received_effect_in_range(effect_to_check : CombatActionEffect) -> bool:
	var in_range : bool = true;

	var effect_range = effect_to_check.effective_range;
	
	if (effect_to_check.target == CombatActionEffect.Target.OTHER):
		# effect came from Player
		in_range = target_other.distance <= effect_range.max_range \
			and target_other.distance >= effect_range.min_range
	
	if (!in_range):
		print("Effect ", effect_to_check, " missed!")

	return in_range

func _apply_move_effect(received_effect : MoveEffect):
	var unlooped_lateral = facing + received_effect.lateral_direction * received_effect.amount
	facing = ((unlooped_lateral + 4) % 4) as Position.Direction
	
	print(self, " turned! New facing is ", facing)
	enemy_turn.emit(facing)

func get_turn_direction_toward_player() -> MoveEffect.LateralDirection:
	var turn_direction_to_player = MoveEffect.LateralDirection.NONE
	
	var player_position_relative_to_self = (target_other.lateral_position - facing + 4) % 4 
	match player_position_relative_to_self:
		0: turn_direction_to_player = MoveEffect.LateralDirection.NONE
		1: turn_direction_to_player = MoveEffect.LateralDirection.CW
		2: turn_direction_to_player = MoveEffect.LateralDirection.OPPOSITE
		3: turn_direction_to_player = MoveEffect.LateralDirection.CCW
	
	return turn_direction_to_player

func get_distance_to_player() -> Position.Ranges:
	return (target_other as Player).distance

func broadcast_threat_warning(triggering_action : Action, head_start : float = 0):
	var threatened_ranges_by_action_state = triggering_action.get_all_threatened_ranges()
	var threatened_positions_charge_start = []
	var threatened_positions_act = []
	var threatened_positions_recovery_end = []
	
	for effectiveRange in threatened_ranges_by_action_state[0]:
		threatened_positions_charge_start \
			.append_array(convert_effective_range_to_position(effectiveRange))
	threat_warning_new.emit(threatened_positions_charge_start, 0, triggering_action)
	
	for effectiveRange in threatened_ranges_by_action_state[1]:
		threatened_positions_act \
			.append_array(convert_effective_range_to_position(effectiveRange))
	threat_warning_new.emit(threatened_positions_act, 
		triggering_action.charge_time - head_start, triggering_action)
	
	for effectiveRange in threatened_ranges_by_action_state[2]:
		threatened_positions_recovery_end \
			.append_array(convert_effective_range_to_position(effectiveRange))
	threat_warning_new.emit(threatened_positions_recovery_end, 
		triggering_action.charge_time + triggering_action.recovery_time - head_start, triggering_action)

func convert_effective_range_to_position(effectiveRange : EffectiveRange) -> Array[Vector2i]:
	var threatened_positions : Array[Vector2i] = []
	for i in range(effectiveRange.min_range, effectiveRange.max_range + 1):
		if (effectiveRange.directions & EffectiveRange.RangeDirections.FRONT):
			threatened_positions.append(Vector2i(facing, i))
		if (effectiveRange.directions & EffectiveRange.RangeDirections.RIGHT):
			threatened_positions.append(Vector2i((facing + 1) % 4, i))
		if (effectiveRange.directions & EffectiveRange.RangeDirections.BACK):
			threatened_positions.append(Vector2i((facing + 2) % 4, i))
		if (effectiveRange.directions & EffectiveRange.RangeDirections.LEFT):
			threatened_positions.append(Vector2i((facing + 3) % 4, i))
	return threatened_positions

func set_current_action(new_value : Action, head_start : float = 0):
	super(new_value, head_start)
	broadcast_threat_warning(new_value, head_start)
