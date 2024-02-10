class_name EffectiveRange extends RefCounted

func _init():
	pass # allow parameterized range objects to be passed in.


# min range
# max range
# lateral slice(s)

func is_in_range(target : Combatant) -> bool :
	return true # TODO: check positioning information (and facing information) to see if in range.
