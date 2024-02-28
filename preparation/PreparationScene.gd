extends Control

signal start_transition_out(transition_data : TransitionData, cleanup_callback : Callable)

@export var is_starting_scene : bool = false

var received_transition_data : TransitionData

func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED
	if self == get_tree().current_scene || is_starting_scene:
		root_scene_actions()
	$BodyContainer/OpenEquipMenuButton.grab_focus()

func begin_exploration():
	_signal_transition_out()

func _on_open_equip_menu_button_pressed():
	$ActionEquipMenu.show()

func _on_loadout_selection_done(player_actions):
	if received_transition_data == null:
		received_transition_data = TransitionData.new()
	received_transition_data.player_data.current_actions = player_actions
	$BodyContainer/OpenEquipMenuButton.grab_focus()

func _on_begin_button_pressed():
	begin_exploration()

#region State Transition Support
func _signal_transition_out():
	if received_transition_data == null:
		received_transition_data = TransitionData.new()
	received_transition_data.next_scene_name = Transition.EXPLORATION
	received_transition_data.exploration_data.reset()
	received_transition_data.player_data.restore()
	start_transition_out.emit(received_transition_data, _cleanup_scene)

func _cleanup_scene():
	queue_free()

func init_scene(transitionData : TransitionData):
	received_transition_data = transitionData

func start_scene():
	process_mode = Node.PROCESS_MODE_INHERIT

func root_scene_actions():
	is_starting_scene = true
	start_scene()
#endregion


