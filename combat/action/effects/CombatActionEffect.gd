class_name CombatActionEffect extends RefCounted

var type : EffectType
var target : Target
var effective_range : EffectiveRange

enum EffectType {
    DAMAGE = 0,
    HEAL = 1,
    STATUS = 2,
    MOVE = 3
}

enum Target {
    SELF = 0,
    OTHER = 1
}