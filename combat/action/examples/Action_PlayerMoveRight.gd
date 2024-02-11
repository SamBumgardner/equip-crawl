class_name Action_PlayerMoveRight extends Action

static var on_act_actions:Array[CombatActionEffect]

func _init():
	name = "Sidestep Right"
	charge_time = 0
	recovery_time = .5
	
	if (on_act_actions.is_empty()):
		var range1 = EffectiveRange.new(Position.Ranges.SHORT, Position.Ranges.LONG, 
			EffectiveRange.RangeDirections.ALL)
		var move_effect = MoveEffect.new(CombatActionEffect.Target.SELF, range1, 1, 
			MoveEffect.LateralDirection.PLAYER_RIGHT, MoveEffect.RangeDirection.NONE)

		on_act_actions = [move_effect] 

func on_act() -> Array[CombatActionEffect]:
	return on_act_actions
