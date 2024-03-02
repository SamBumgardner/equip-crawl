class_name Action_PlayerMoveRight extends Action

static var on_act_actions:Array[CombatActionEffect]

func _init():
	name = "Sidestep Right"
	charge_time = 0
	recovery_time = .25
	display_cast_bar = false
	icon = preload("res://art/input_display/action_icons/move_right.png")
	max_uses = 7
	remaining_uses = 7
	
	if (on_act_actions.is_empty()):
		var range1 = EffectiveRange.new(Position.Ranges.SHORT, Position.Ranges.LONG, 
			EffectiveRange.RangeDirections.ALL)
		var move_effect = MoveEffect.new(CombatActionEffect.Target.SELF, range1, 1, 
			MoveEffect.LateralDirection.CCW, MoveEffect.RangeDirection.NONE)
		var visual_effect = VisualEffect.new("player_move_ccw")

		on_act_actions = [move_effect, visual_effect] 

func on_act() -> Array[CombatActionEffect]:
	return on_act_actions
