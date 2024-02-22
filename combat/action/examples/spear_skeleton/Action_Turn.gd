class_name Action_Turn extends Action

static var on_act_actions:Array[CombatActionEffect]

static var last_turn_direction = -1

func _init(owning_enemy : Enemy):
	enemy = owning_enemy
	
	name = "Refocus"
	charge_time = .5
	recovery_time = 0
	display_cast_bar = false
	
	if (on_act_actions.is_empty()):
		var turn_effect = MoveEffect.new(CombatActionEffect.Target.SELF, null,
			1, MoveEffect.LateralDirection.CW, MoveEffect.RangeDirection.NONE)
		on_act_actions = [turn_effect] 

func _update_turn_effect_toward_player():
	var turn_direction = enemy.get_turn_direction_toward_player()
	if turn_direction == MoveEffect.LateralDirection.OPPOSITE:
		turn_direction = last_turn_direction * -1
		last_turn_direction = turn_direction
	
	(on_act_actions[0] as MoveEffect).lateral_direction = turn_direction

func on_act() -> Array[CombatActionEffect]:
	_update_turn_effect_toward_player()
	return on_act_actions
