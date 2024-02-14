class_name Action_PlayerMoveForward extends Action

static var on_act_actions:Array[CombatActionEffect]

func _init():
	name = "Step Forward"
	charge_time = 0
	recovery_time = .25
	
	if (on_act_actions.is_empty()):
		var range1 = EffectiveRange.new(Position.Ranges.SHORT, Position.Ranges.LONG, 
			EffectiveRange.RangeDirections.ALL)
		var move_effect = MoveEffect.new(CombatActionEffect.Target.SELF, range1, 1, 
			MoveEffect.LateralDirection.NONE, MoveEffect.RangeDirection.PLAYER_FORWARD)

		on_act_actions = [move_effect] 

func on_act() -> Array[CombatActionEffect]:
	return on_act_actions
