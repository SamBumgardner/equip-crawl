class_name Action_OnionLayeredAssault extends Action

var on_act_actions : Array[CombatActionEffect]
var on_charge_start_actions : Array[CombatActionEffect]

func _init(owning_enemy : Enemy, target_range : Position.Ranges, cast_time_mult = 1):
	enemy = owning_enemy
	
	name = "Layered Assault"
	charge_time = 2.5 * cast_time_mult
	recovery_time = .5 * cast_time_mult
	
	if (on_charge_start_actions.is_empty()):
		var visual_effect = VisualEffect.new("enemy_charge")
		on_charge_start_actions = [visual_effect]
	
	if (on_act_actions.is_empty()):
		var range1 = EffectiveRange.new(target_range, target_range, EffectiveRange.RangeDirections.ALL)
		var damage_effect = DamageEffect.new(CombatActionEffect.Target.OTHER, range1, 1)
		var visual_effect = VisualEffect.new("enemy_squish")
		on_act_actions = [damage_effect, visual_effect]

func on_charge_start():
	return on_charge_start_actions

func on_act() -> Array[CombatActionEffect]:
	return on_act_actions
