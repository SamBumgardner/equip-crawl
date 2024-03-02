class_name ActorState extends RefCounted

var owner : Combatant
var state_change : StateChange = StateChange.new()
var time_remaining : float

func _init(init_owner : Combatant = null):
	owner = init_owner

func _initalize_owner(init_owner : Combatant):
	owner = init_owner

func enter():
	pass

func exit():
	pass

func physics_process(delta : float) -> StateChange:
	return state_change
