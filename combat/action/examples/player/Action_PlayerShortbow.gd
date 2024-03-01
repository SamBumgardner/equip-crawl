class_name Action_PlayerShortbow extends Action

static var on_act_actions:Array[CombatActionEffect]
static var on_charge_actions:Array[CombatActionEffect]

func _init():
	name = "Shortbow"
	charge_time = 1.25
	recovery_time = .5
	icon = preload("res://art/input_display/action_icons/shortbow.png")
	max_uses = 10
	remaining_uses = 10
	
	if (on_act_actions.is_empty()):
		var range1 = EffectiveRange.new(Position.Ranges.SHORT, Position.Ranges.MEDIUM, 
			EffectiveRange.RangeDirections.ALL)
		var damage_effect = DamageEffect.new(CombatActionEffect.Target.OTHER, range1, 2)
		var visual_effect = VisualEffect.new("player_bounce_forward")
		on_act_actions = [damage_effect, visual_effect] 
	
	if (on_charge_actions.is_empty()):
		var visual_effect = VisualEffect.new("player_charge")
		on_charge_actions = [visual_effect]

func on_act() -> Array[CombatActionEffect]:
	return on_act_actions

func on_charge_start() -> Array[CombatActionEffect]:
	return on_charge_actions
