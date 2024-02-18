class_name MoveEffect extends CombatActionEffect

var amount : int
var lateral_direction : LateralDirection
var range_direction : RangeDirection

func _init(target_in : CombatActionEffect.Target, 
		range_in : EffectiveRange,
		amount_in : int,
		lateral_direction_in : LateralDirection,
		range_direction_in : RangeDirection
	):
	self.amount = amount_in
	self.lateral_direction = lateral_direction_in
	self.range_direction = range_direction_in
	self.type = CombatActionEffect.EffectType.MOVE
	self.target = target
	self.effective_range = range_in

enum LateralDirection {
	CW  =  1,
	CCW = -1,
	NONE = 0,
	OPPOSITE = 2
}

enum RangeDirection {
	PLAYER_FORWARD  = -1,
	PLAYER_BACKWARD =  1,
	NONE = 0
}
