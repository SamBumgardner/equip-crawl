class_name VisualEffect extends CombatActionEffect

var visual_effect_to_play : String = ""

func _init(effect_to_play : String):
	type = CombatActionEffect.EffectType.VISUAL
	visual_effect_to_play = effect_to_play
