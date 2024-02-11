class_name Combatant extends Node

signal combatant_defeated(combatant)
signal health_changed(new_value)

@export var health : float:
	get:
		return health
	set(value):
		health = value
		health_changed.emit(health)
		if value <= 0:
			combatant_defeated.emit(self)

@export var target_other : Combatant

var state_machine : StateMachine 
var possible_states : Array[ActorState] # child classes are responsible for setting this up in _init()
# current_status_effects
var available_actions : Array[Action]
var current_action : Action

func _ready():
	state_machine = StateMachine.new()
	state_machine.initialize(possible_states, CombatantStates.States.IDLE)

func _physics_process(delta):
	state_machine.physics_process(delta)

func send_current_act_effects():
	var combat_effects = current_action.on_act()
	#TODO: run effects through ongoing statuses, then send em to their target
	var target_self_effects : Array[CombatActionEffect] = []
	var target_other_effects : Array[CombatActionEffect] = []

	for effect in combat_effects:
		if (effect.target == CombatActionEffect.Target.SELF):
			target_self_effects.append(effect)
		elif (effect.target == CombatActionEffect.Target.OTHER):
			target_other_effects.append(effect)
	
	if (target_self_effects.size() > 0):
		self.receive_act_effects(target_self_effects)
	if (target_other_effects.size() > 0):
		target_other.receive_act_effects(target_other_effects)

func receive_act_effects(received_effects: Array[CombatActionEffect]):
	print("owner ", self, " received action effects: ", received_effects)
	received_effects.filter(_is_effect_in_range)
	#TODO: run effects through ongoing statuses, then accept the results
	received_effects.map(_apply_received_effect)

func _apply_received_effect(received_effect : CombatActionEffect):
	match received_effect.type:
		CombatActionEffect.EffectType.DAMAGE:
			var incoming_damage = (received_effect as DamageEffect).amount
			health -= incoming_damage
			print("owner ", self, "ouch, just took ", incoming_damage, " damage, only ", health, " health remaining!")
		CombatActionEffect.EffectType.HEAL:
			var incoming_heal = (received_effect as HealEffect).amount
			health += incoming_heal
			print("owner ", self, "whew, just got ", incoming_heal, " healing, I have ", health, " health remaining!")
		CombatActionEffect.EffectType.STATUS:
			pass
		CombatActionEffect.EffectType.MOVE:
			#TODO: call overridden function for handling movement effects(?)
			pass

func _is_effect_in_range(effect_to_check : CombatActionEffect) -> bool:
	return true # Child classes should override this, they know how to check if they're in range or not.