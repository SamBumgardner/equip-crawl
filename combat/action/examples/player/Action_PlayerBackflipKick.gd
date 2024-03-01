class_name Action_PlayerBackflipKick extends Action

static var on_act_actions:Array[CombatActionEffect]
static var on_recovery_end_actions:Array[CombatActionEffect]

func _init():
	name = "Backflip Kick"
	charge_time = .25
	recovery_time = .1
	icon = preload("res://art/input_display/action_icons/backflip_kick.png")
	max_uses = 5
	remaining_uses = 5
	
	if (on_act_actions.is_empty()):
		var range1 = EffectiveRange.new(Position.Ranges.SHORT, Position.Ranges.SHORT, 
			EffectiveRange.RangeDirections.ALL) 
		var damage_effect = DamageEffect.new(CombatActionEffect.Target.OTHER, range1, 2)
		var visual_effect = VisualEffect.new("player_bounce_forward")
		on_act_actions = [damage_effect, visual_effect] 
	
	if (on_recovery_end_actions.is_empty()):
		var move_effect = MoveEffect.new(CombatActionEffect.Target.SELF, null, 1, 
			MoveEffect.LateralDirection.NONE, MoveEffect.RangeDirection.PLAYER_OUT)
		var visual_effect = VisualEffect.new("player_move_out")
		on_recovery_end_actions = [move_effect, visual_effect]

func on_act() -> Array[CombatActionEffect]:
	return on_act_actions

func on_recovery_end() -> Array[CombatActionEffect]:
	return on_recovery_end_actions
