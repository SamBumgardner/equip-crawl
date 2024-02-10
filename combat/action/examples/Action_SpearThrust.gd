class_name Action_SpearThrust extends Action

static var on_act_actions:Array[CombatActionEffect] = [ 
    DamageEffect.new(5) 
]

func _init():
    name = "Spear Thrust"
    charge_time = 2
    recovery_time = 1

func on_act() -> Array[CombatActionEffect]:
    return on_act_actions