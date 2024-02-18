class_name Action_PlayerPowerAttack extends Action

static var on_act_actions:Array[CombatActionEffect]

func _init():
	name = "Power Attack"
	charge_time = .75
	recovery_time = .5
	
	if (on_act_actions.is_empty()):
		var range1 = EffectiveRange.new(Position.Ranges.SHORT, Position.Ranges.SHORT, 
			EffectiveRange.RangeDirections.ALL)
		var damage_effect = DamageEffect.new(CombatActionEffect.Target.OTHER, range1, 4)

		on_act_actions = [damage_effect] 

func on_act() -> Array[CombatActionEffect]:
	return on_act_actions
