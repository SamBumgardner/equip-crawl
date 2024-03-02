class_name Action_PlayerAttack extends Action

static var on_act_actions:Array[CombatActionEffect]

func _init():
	name = "Basic Attack"
	charge_time = 0
	recovery_time = .5
	icon = preload("res://art/input_display/action_icons/basic_attack.png")
	max_uses = 12
	remaining_uses = 12
	
	if (on_act_actions.is_empty()):
		var range1 = EffectiveRange.new(Position.Ranges.SHORT, Position.Ranges.SHORT, 
			EffectiveRange.RangeDirections.ALL)
		var damage_effect = DamageEffect.new(CombatActionEffect.Target.OTHER, range1, 2)
		var visual_effect = VisualEffect.new("player_bounce_forward")

		on_act_actions = [damage_effect, visual_effect] 

func on_act() -> Array[CombatActionEffect]:
	return on_act_actions
