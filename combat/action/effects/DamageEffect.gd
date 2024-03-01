class_name DamageEffect extends CombatActionEffect

var amount : int
var element : DamageElement

func _init(target_in:Target = Target.OTHER,
		range_in:EffectiveRange = null, 
		amount_in:int = 0, 
		element_in:DamageElement = DamageElement.PHYSICAL
	):
	type = CombatActionEffect.EffectType.DAMAGE
	target = target_in
	effective_range = range_in
	amount = amount_in
	element = element_in

func _to_string():
	var parent = EffectType.find_key(type) + " w/ range " +  (effective_range.to_string() if effective_range != null else "ALL")
	return parent + ", %s damage %d" % [DamageElement.find_key(element), amount]

enum DamageElement {
	PHYSICAL = 0
}
