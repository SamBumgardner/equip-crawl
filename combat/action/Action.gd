class_name Action extends RefCounted

var name : String = "unset action name"
var charge_time : float = 0
var recovery_time : float = 0

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
