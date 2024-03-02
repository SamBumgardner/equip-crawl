class_name Action_OnionScallionStrike extends Action

const BASE_CHARGE = 2.5
const BASE_RECOVERY = .5

var on_act_actions : Array[CombatActionEffect]
var on_charge_start_actions : Array[CombatActionEffect]

func _init(owning_enemy : Enemy):
	enemy = owning_enemy
	
	name = "Scallion Strike"
	charge_time = BASE_CHARGE
	recovery_time = BASE_RECOVERY
	
	if (on_charge_start_actions.is_empty()):
		var visual_effect = VisualEffect.new("enemy_charge")
		on_charge_start_actions = [visual_effect]
	
	if (on_act_actions.is_empty()):
		var range1 = EffectiveRange.new(Position.Ranges.SHORT, Position.Ranges.SHORT, EffectiveRange.RangeDirections.FRONT)
		var damage_effect = DamageEffect.new(CombatActionEffect.Target.OTHER, range1, 1)
		var visual_effect = VisualEffect.new("enemy_squeeze")
		on_act_actions = [damage_effect, visual_effect]

func set_rate(speed_mult : float, skip_recovery : bool = false):
	charge_time = BASE_CHARGE * speed_mult
	recovery_time = BASE_RECOVERY * speed_mult
	if skip_recovery:
		recovery_time = 0

func on_charge_start():
	var target_distance = enemy.get_distance_to_player()
	var target_direction = enemy.get_range_direction_toward_player()
	on_act_actions[0].effective_range = EffectiveRange.new(target_distance, target_distance, target_direction)
	return on_charge_start_actions

func on_act() -> Array[CombatActionEffect]:
	return on_act_actions
