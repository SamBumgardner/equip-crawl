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

# TODO: Create some function to "compile" the threat ranges of upcoming attacks.
# Need to communicate that out in one way or another.