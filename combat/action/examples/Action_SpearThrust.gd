class_name Action_SpearThrust extends Action

static var on_act_actions:Array[CombatActionEffect]

func _init():
	name = "Spear Thrust"
	charge_time = 2
	recovery_time = 1
	
	if (on_act_actions.is_empty()):
		var range1 = EffectiveRange.new(Position.Ranges.SHORT, Position.Ranges.SHORT, 
			EffectiveRange.RangeDirections.FRONT)
		var damage_effect = DamageEffect.new(CombatActionEffect.Target.OTHER, range1, 5)

		on_act_actions = [damage_effect] 

func on_act() -> Array[CombatActionEffect]:
	return on_act_actions
