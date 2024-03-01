class_name Action_PlayerLeap extends Action

static var short_range_effects:Array[CombatActionEffect]
static var medium_range_effects:Array[CombatActionEffect]
static var long_range_effects:Array[CombatActionEffect]

func _init():
	name = "Leap"
	charge_time = .4
	recovery_time = .1
	icon = preload("res://art/input_display/action_icons/leap.png")
	
	var normal_jump_visual = VisualEffect.new("player_bounce_forward")
	
	if short_range_effects.is_empty():
		var jump_behind = MoveEffect.new(CombatActionEffect.Target.SELF, null, 2, 
			MoveEffect.LateralDirection.CW, MoveEffect.RangeDirection.NONE)
		short_range_effects = [jump_behind, normal_jump_visual]
	
	if medium_range_effects.is_empty():
		# land on em, both get hit, player's at close range
		var jump_close = MoveEffect.new(CombatActionEffect.Target.SELF, null, 1, 
			MoveEffect.LateralDirection.NONE, MoveEffect.RangeDirection.PLAYER_IN)
		#var self_damage = DamageEffect.new(CombatActionEffect.Target.SELF, null, 1) # non-intuitive and hard to communicate
		var other_damage = DamageEffect.new(CombatActionEffect.Target.OTHER, null, 2)
		# need alternate visual effect
		medium_range_effects = [jump_close, other_damage]
	
	if long_range_effects.is_empty():
		var jump_close = MoveEffect.new(CombatActionEffect.Target.SELF, null, 2, 
			MoveEffect.LateralDirection.NONE, MoveEffect.RangeDirection.PLAYER_IN)
		long_range_effects = [jump_close, normal_jump_visual]

func on_act() -> Array[CombatActionEffect]:
	match player.distance:
		Position.Ranges.SHORT:
			return short_range_effects
		Position.Ranges.MEDIUM:
			return medium_range_effects
		Position.Ranges.LONG:
			return long_range_effects
		_:
			return []
	
