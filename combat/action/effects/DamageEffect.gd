class_name DamageEffect extends CombatActionEffect

var amount : int
var element : DamageElement

func _init(initTarget:Target = Target.OTHER,
        initRange:EffectiveRange = null, 
        initAmount:int = 0, 
        initElement:DamageElement = DamageElement.PHYSICAL
    ):
    type = CombatActionEffect.EffectType.DAMAGE
    target = initTarget
    effective_range = initRange
    amount = initAmount
    element = initElement

enum DamageElement {
    PHYSICAL = 0
}
