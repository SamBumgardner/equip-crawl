class_name Combatant extends Node

signal combatant_defeated(combatant)
signal health_changed(new_value, max_value)
signal state_changed(new_state, duration, current_action)
signal visual_effect_triggered(effect_name : String, origin : CombatActionEffect)

@export var max_health : float:
	set(value):
		max_health = value
		if (is_inside_tree()):
			health_changed.emit(health, max_health)
		
@export  var health : float:
	set(value):
		health = value
		if (is_inside_tree()):
			health_changed.emit(health, max_health)
		if value <= 0:
			combatant_defeated.emit(self)

@export var target_other : Combatant

var state_machine : StateMachine 
var possible_states : Array[ActorState] # child classes are responsible for setting this up in _init()
var hurt_visual_effect : VisualEffect # child classes are responsible for setting this up in _init
var block_visual_effect : VisualEffect # child classes are responsible for setting this up in _init
# current_status_effects
var available_actions : Array[Action]
var _current_action : Action

func _ready():
	state_machine = StateMachine.new()
	state_machine.initialize(self, possible_states, CombatantStates.States.IDLE)

func _physics_process(delta):
	state_machine.physics_process(delta)

func send_combat_effects(current_state : CombatantStates.States):
	var combat_effects : Array[CombatActionEffect]
	
	match current_state:
		CombatantStates.States.CHARGE:
			combat_effects = _current_action.on_charge_start()
		CombatantStates.States.ACT:
			combat_effects = _current_action.on_act()
		_:
			combat_effects = []
	
	#TODO: run effects through ongoing statuses, then send em to their target
	var target_self_effects : Array[CombatActionEffect] = []
	var target_other_effects : Array[CombatActionEffect] = []

	for effect in combat_effects:
		if (effect.target == CombatActionEffect.Target.SELF):
			target_self_effects.append(effect)
		elif (effect.target == CombatActionEffect.Target.OTHER):
			target_other_effects.append(effect)
	
	if (target_self_effects.size() > 0):
		self.receive_combat_effects(target_self_effects)
	if (target_other_effects.size() > 0):
		target_other.receive_combat_effects(target_other_effects)

func receive_combat_effects(received_effects: Array[CombatActionEffect]):
	print(self, " received action effects: ", received_effects)
	received_effects.filter(_is_received_effect_in_range) \
	#TODO: run effects through ongoing statuses, then accept the results
		.map(_apply_received_effect)

# Child classes should override this, they know how to check if they're in range or not.
func _is_received_effect_in_range(effect_to_check : CombatActionEffect) -> bool:
	return true 

func _apply_received_effect(received_effect : CombatActionEffect):
	match received_effect.type:
		CombatActionEffect.EffectType.DAMAGE:
			_apply_damage_effect(received_effect)
		CombatActionEffect.EffectType.HEAL:
			var incoming_heal = (received_effect as HealEffect).amount
			health += incoming_heal
			print(self, " got ", incoming_heal, " healing. ", health, " health remaining.")
		CombatActionEffect.EffectType.STATUS:
			pass
		CombatActionEffect.EffectType.MOVE:
			_apply_move_effect(received_effect)
		CombatActionEffect.EffectType.VISUAL:
			visual_effect_triggered.emit(received_effect.visual_effect_to_play, received_effect)

func _apply_damage_effect(received_effect : DamageEffect):
	var incoming_damage = received_effect.amount
	health -= incoming_damage
	health_changed.emit(health, max_health)
	
	if incoming_damage > 0:
		visual_effect_triggered.emit(hurt_visual_effect.visual_effect_to_play, hurt_visual_effect)
	elif incoming_damage == 0:
		visual_effect_triggered.emit(block_visual_effect.visual_effect_to_play, block_visual_effect)
	
	print(self, " took ", incoming_damage, " damage. ", health, " health remaining.")

# Abstract. Child classes should override this for functionality.
func _apply_move_effect(received_effect : MoveEffect):
	pass


func set_current_action(new_action : Action, _head_start : float = 0):
	_current_action = new_action
