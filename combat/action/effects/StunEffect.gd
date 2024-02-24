class_name StunEffect extends CombatActionEffect

var duration : float

func _init(target_in:Target = Target.OTHER,
		range_in:EffectiveRange = null, 
		duration_in:float = 0, 
	):
	type = CombatActionEffect.EffectType.STUN
	target = target_in
	effective_range = range_in
	duration = duration_in

func _to_string():
	var parent = EffectType.find_key(type) + " w/ range " + effective_range.to_string()
	return parent + ", stun for %s seconds" % [duration]
