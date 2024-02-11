class_name CombatActionEffect extends RefCounted

var type : EffectType
var target : Target
var effective_range : EffectiveRange # If this is null, the thing is always in range.

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
