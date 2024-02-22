class_name Action_PlayerPowerAttack extends Action

static var on_act_actions:Array[CombatActionEffect]
static var on_charge_start_actions:Array[CombatActionEffect]

func _init():
	name = "Power Attack"
	charge_time = .75
	recovery_time = .5
	
	if (on_act_actions.is_empty()):
		var range1 = EffectiveRange.new(Position.Ranges.SHORT, Position.Ranges.SHORT, 
			EffectiveRange.RangeDirections.ALL)
		var damage_effect = DamageEffect.new(CombatActionEffect.Target.OTHER, range1, 4)
		var visual_effect = VisualEffect.new("player_slash")

		on_act_actions = [damage_effect, visual_effect] 
	
	if (on_charge_start_actions.is_empty()):
		var visual_effect = VisualEffect.new("player_charge")
		on_charge_start_actions = [visual_effect]

func on_act() -> Array[CombatActionEffect]:
	return on_act_actions

func on_charge_start() -> Array[CombatActionEffect]:
	return on_charge_start_actions
