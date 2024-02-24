class_name VisualEffect extends CombatActionEffect

var visual_effect_to_play : String = ""

func _init(effect_to_play : String, target_in:Target = Target.SELF,
		range_in:EffectiveRange = null):
	type = CombatActionEffect.EffectType.VISUAL
	visual_effect_to_play = effect_to_play
	target = target_in
	effective_range = range_in
