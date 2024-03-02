class_name Action_RangeMove extends Action

static var on_act_actions:Array[CombatActionEffect]

var target_range : Position.Ranges

func _init(owning_enemy : Enemy, target_range_in : Position.Ranges, 
		charge_time_in : float, recovery_time_in : float):
	enemy = owning_enemy
	target_range = target_range_in
	
	name = "Reposition"
	charge_time = charge_time_in
	recovery_time = recovery_time_in
	display_cast_bar = false
	
	if (on_act_actions.is_empty()):
		var move_effect = MoveEffect.new(CombatActionEffect.Target.OTHER, null,
			1, MoveEffect.LateralDirection.NONE, MoveEffect.RangeDirection.NONE)
		var visual_effect = VisualEffect.new("enemy_move")
		on_act_actions = [move_effect, visual_effect] 

func _update_move_effect_toward_target_range():
	var move_direction = target_range - enemy.get_distance_to_player()
	(on_act_actions[0] as MoveEffect).range_direction = sign(move_direction)
	
	if move_direction < 0:
		name = "Advance"
	elif move_direction > 0:
		name = "Retreat"

func on_charge_start() -> Array[CombatActionEffect]:
	_update_move_effect_toward_target_range()
	return []

func on_act() -> Array[CombatActionEffect]:
	return on_act_actions
