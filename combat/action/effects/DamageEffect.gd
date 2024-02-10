class_name DamageEffect extends CombatActionEffect

var amount : int
var element : DamageElement

func _init(Amount:int = 0, Element:DamageElement = DamageElement.PHYSICAL):
    amount = Amount
    element = Element

enum DamageElement {
    PHYSICAL = 0
}
