class_name Action extends RefCounted

var name : String = "unset action name"
var charge_time : float = 0
var recovery_time : float = 0
var display_cast_bar : bool = true

# This may be better refactored to just be included on actions that need it,
#  but it's more convenient to expose it here for now.
var player : Player
var enemy : Enemy

func _to_string():
	return name

func on_act() -> Array[CombatActionEffect]:
	return []

func on_charge_start() -> Array[CombatActionEffect]:
	return []

func on_recovery_start() -> Array[CombatActionEffect]:
	return []

func report_ranges():
	for combat_effect in on_act():
		if (combat_effect.type == CombatActionEffect.EffectType.DAMAGE):
			print("incoming attack at ranges ", combat_effect.effective_range, " in ", charge_time, " seconds ")
# TODO: Create some function to "compile" the threat ranges of upcoming attacks.
# Need to communicate that out in one way or another.
