class_name Action_OnionRollout extends Action

static var on_act_actions : Array[CombatActionEffect]
static var on_recovery_start_actions : Array[CombatActionEffect]

static var last_turn_direction = -1

func _init(owning_enemy : Enemy):
	enemy = owning_enemy
	
	name = "Bonk"
	charge_time = 2
	recovery_time = 1
	
	if (on_act_actions.is_empty()):
		var range1 = EffectiveRange.new(Position.Ranges.SHORT, Position.Ranges.SHORT, 
			EffectiveRange.RangeDirections.FRONT)
		var damage_effect = DamageEffect.new(CombatActionEffect.Target.OTHER, range1, 1)
		var visual_effect = VisualEffect.new("enemy_lunge")
		on_act_actions = [damage_effect, visual_effect]

func on_act() -> Array[CombatActionEffect]:
	return on_act_actions
