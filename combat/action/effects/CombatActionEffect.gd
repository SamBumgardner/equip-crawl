class_name CombatActionEffect extends RefCounted

var type : EffectType
var target : Target
var effective_range : EffectiveRange # If this is null, the thing is always in range.

func _init(type_in : EffectType,
		target_in : Target,
		effective_range_in : EffectiveRange):
	type = type_in
	target = target_in
	effective_range = effective_range_in

func _to_string():
	return EffectType.find_key(type) + " w/ range " + effective_range.to_string()

enum EffectType {
	DAMAGE = 0,
	HEAL   = 1,
	STATUS = 2,
	MOVE   = 3
}

enum Target {
	SELF  = 0,
	OTHER = 1
}
