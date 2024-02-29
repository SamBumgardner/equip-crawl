class_name Action extends Resource

var name : String = "unset action name"
var charge_time : float = 0
var recovery_time : float = 0
var display_cast_bar : bool = true

var max_uses : int = 10
var remaining_uses : int = 10
var icon : Texture2D = preload("res://art/input_display/action_icons/unknown.png")

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

func on_recovery_end() -> Array[CombatActionEffect]:
	return []

func get_all_threatened_ranges():
	var threatened_ranges = []
	threatened_ranges.append(_extract_threatened_ranges(on_charge_start()))
	threatened_ranges.append(_extract_threatened_ranges(on_act()))
	threatened_ranges.append(_extract_threatened_ranges(on_recovery_end()))
	
	return threatened_ranges

func _extract_threatened_ranges(effects_to_check : Array[CombatActionEffect]):
	var result : Array[EffectiveRange] = []
	for effect in effects_to_check:
		if effect.type == CombatActionEffect.EffectType.DAMAGE \
				and effect.target == CombatActionEffect.Target.OTHER:
			result.append(effect.effective_range)
	return result

func consume_use() -> bool:
	if remaining_uses > 0:
		remaining_uses -= 1
		return true
	return false
