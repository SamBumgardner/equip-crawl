class_name Combatant extends Node

@export var health : float
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
	# run effects through ongoing statuses, then send em to their target
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
	print("Received action effects: ", received_effects)
	pass # todo: take in list of stuff to do
