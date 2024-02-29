class_name Action_PlayerLongbow extends Action

static var on_act_actions:Array[CombatActionEffect]
static var on_charge_actions:Array[CombatActionEffect]

func _init():
	name = "Longbow"
	charge_time = 1.65
	recovery_time = .5
	#icon = preload("res://art/input_display/action_icons/basic_attack.png")
	max_uses = 10
	remaining_uses = 10
	
	if (on_charge_actions.is_empty()):
		var visual_effect = VisualEffect.new("player_charge")
	
	if (on_act_actions.is_empty()):
		var range1 = EffectiveRange.new(Position.Ranges.MEDIUM, Position.Ranges.LONG, 
			EffectiveRange.RangeDirections.ALL)
		var damage_effect = DamageEffect.new(CombatActionEffect.Target.OTHER, range1, 4)
		var visual_effect = VisualEffect.new("player_bounce_forward")
		on_act_actions = [damage_effect, visual_effect] 


func on_act() -> Array[CombatActionEffect]:
	return on_act_actions
