class_name Action_Turn extends Action

static var on_act_actions:Array[CombatActionEffect]

var initialized_turn_direction = -1

func _init(owning_enemy : Enemy, charge_time_in : float, recovery_time_in : float):
	enemy = owning_enemy
	
	name = "Refocus"
	charge_time = charge_time_in
	recovery_time = recovery_time_in
	display_cast_bar = false
	
	initialized_turn_direction = randi_range(0, 1)
	if initialized_turn_direction == 0:
		initialized_turn_direction = -1
	
	if (on_act_actions.is_empty()):
		var turn_effect = MoveEffect.new(CombatActionEffect.Target.SELF, null,
			1, MoveEffect.LateralDirection.CW, MoveEffect.RangeDirection.NONE)
		on_act_actions = [turn_effect] 

func _update_turn_effect_toward_player():
	var turn_direction = enemy.get_turn_direction_toward_player()
	if turn_direction == MoveEffect.LateralDirection.OPPOSITE:
		turn_direction = initialized_turn_direction
	
	(on_act_actions[0] as MoveEffect).lateral_direction = turn_direction

func on_act() -> Array[CombatActionEffect]:
	_update_turn_effect_toward_player()
	return on_act_actions
