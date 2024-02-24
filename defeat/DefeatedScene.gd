extends Control

signal start_transition_out(transition_data : TransitionData, cleanup_callback : Callable)

@export var is_starting_scene : bool = false
@export var current_floor_number : int = 0

@onready var floor_number_label : Label = $FloorNumberDisplay/FloorNumber

var received_transition_data : TransitionData

func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED
	if self == get_tree().current_scene || is_starting_scene:
		root_scene_actions()
	increment_floor_number()

func _input(event : InputEvent):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		continue_exploration()
		get_viewport().set_input_as_handled()

func continue_exploration():
	_signal_transition_out()

func increment_floor_number():
	current_floor_number += 1
	floor_number_label.text = str(current_floor_number)

#region State Transition Support
func _signal_transition_out():
	if received_transition_data == null:
		received_transition_data = TransitionData.new()
	received_transition_data.next_scene_name = Transition.PREPARATION
	start_transition_out.emit(received_transition_data, _cleanup_scene)

func _cleanup_scene():
	queue_free()

func init_scene(transitionData : TransitionData):
	current_floor_number = transitionData.exploration_data.floor_number
	received_transition_data = transitionData

func start_scene():
	process_mode = Node.PROCESS_MODE_INHERIT

func root_scene_actions():
	is_starting_scene = true
	start_scene()
#endregion
