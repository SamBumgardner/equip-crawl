class_name Action_MidrangeMove extends Action

static var on_act_actions:Array[CombatActionEffect]

func _init(owning_enemy : Enemy):
	enemy = owning_enemy
	
	name = "Reposition"
	charge_time = .5
	recovery_time = 0
	
	if (on_act_actions.is_empty()):
		var move_effect = MoveEffect.new(CombatActionEffect.Target.OTHER, null,
			1, MoveEffect.LateralDirection.NONE, MoveEffect.RangeDirection.NONE)
		on_act_actions = [move_effect] 

func _update_move_effect_to_stay_medium():
	var move_direction = Position.Ranges.MEDIUM - enemy.get_distance_to_player()
	(on_act_actions[0] as MoveEffect).range_direction = move_direction
	
	if move_direction < 0:
		name = "Advance"
	elif move_direction > 0:
		name = "Retreat"

func on_charge_start() -> Array[CombatActionEffect]:
	_update_move_effect_to_stay_medium()
	return []

func on_act() -> Array[CombatActionEffect]:
	return on_act_actions
