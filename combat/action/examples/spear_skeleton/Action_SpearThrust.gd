class_name Action_SpearThrust extends Action

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
		var damage_effect = DamageEffect.new(CombatActionEffect.Target.OTHER, range1, 0)
		var visual_effect = VisualEffect.new("enemy_lunge")

		on_act_actions = [damage_effect, visual_effect] 

func on_act() -> Array[CombatActionEffect]:
	return on_act_actions
