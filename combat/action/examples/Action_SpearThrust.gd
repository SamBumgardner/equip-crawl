class_name Action_SpearThrust extends Action

static var on_charge_start_actions:Array[CombatActionEffect]
static var on_act_actions:Array[CombatActionEffect]

static var last_turn_direction = -1

func _init(owning_enemy : Enemy):
	enemy = owning_enemy
	
	name = "Spear Thrust"
	charge_time = 2
	recovery_time = 1
	
	if (on_act_actions.is_empty()):
		var range1 = EffectiveRange.new(Position.Ranges.SHORT, Position.Ranges.MEDIUM, 
			EffectiveRange.RangeDirections.FRONT)
		var damage_effect = DamageEffect.new(CombatActionEffect.Target.OTHER, range1, 5)

		on_act_actions = [damage_effect] 
	
	if (on_charge_start_actions.is_empty()):
		var turn_effect = MoveEffect.new(CombatActionEffect.Target.SELF, null,
			1, MoveEffect.LateralDirection.CW, MoveEffect.RangeDirection.NONE)
		var move_effect = MoveEffect.new(CombatActionEffect.Target.OTHER, null,
			1, MoveEffect.LateralDirection.NONE, MoveEffect.RangeDirection.NONE)
		on_charge_start_actions = [turn_effect, move_effect]


func _update_turn_effect_toward_player():
	var turn_direction = enemy.get_turn_direction_toward_player()
	if turn_direction == MoveEffect.LateralDirection.OPPOSITE:
		turn_direction = last_turn_direction * -1
		last_turn_direction = turn_direction
	
	(on_charge_start_actions[0] as MoveEffect).lateral_direction = turn_direction

func _update_move_effect_to_stay_medium():
	var move_direction = Position.Ranges.MEDIUM - enemy.get_distance_to_player()
	(on_charge_start_actions[1] as MoveEffect).range_direction = move_direction
	

func on_charge_start() -> Array[CombatActionEffect]:
	_update_turn_effect_toward_player()
	_update_move_effect_to_stay_medium()

	return on_charge_start_actions

func on_act() -> Array[CombatActionEffect]:
	return on_act_actions
