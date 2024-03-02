extends Control

signal start_transition_out(transition_data : TransitionData, cleanup_callback : Callable)

@export var is_starting_scene : bool = false

@onready var action_equip_menu : ActionEquipMenu = $ActionEquipMenu

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
	$BodyContainer/OpenEquipMenuButton.focus_mode = FOCUS_NONE
	$FooterContainer/BeginButton.focus_mode = FOCUS_NONE

func _on_loadout_selection_done(player_actions):
	if received_transition_data == null:
		received_transition_data = TransitionData.new()
	received_transition_data.player_data.current_actions = player_actions
	$BodyContainer/OpenEquipMenuButton.focus_mode = FOCUS_ALL
	$FooterContainer/BeginButton.focus_mode = FOCUS_ALL
	$BodyContainer/OpenEquipMenuButton.grab_focus()

func _on_begin_button_pressed():
	begin_exploration()

#region State Transition Support
func _signal_transition_out():
	if received_transition_data == null:
		received_transition_data = TransitionData.new()
	received_transition_data.next_scene_name = Transition.EXPLORATION
	received_transition_data.player_data.available_actions = received_transition_data.player_data.current_actions.filter(func(x):return x != null)
	start_transition_out.emit(received_transition_data, _cleanup_scene)
	# need to stop own input processing:
	process_mode = Node.PROCESS_MODE_DISABLED

func _cleanup_scene():
	queue_free()

func init_scene(transitionData : TransitionData):
	received_transition_data = transitionData
	transitionData.player_data = TransitionData.PlayerData.new()
	transitionData.player_data.restore()
	transitionData.progression_data.refresh_action_uses()
	received_transition_data.exploration_data.reset()

func start_scene():
	process_mode = Node.PROCESS_MODE_INHERIT
	if received_transition_data == null:
		received_transition_data = TransitionData.new()
	action_equip_menu.set_possible_actions(received_transition_data.progression_data.unlocked_actions, received_transition_data.player_data.current_actions)

func root_scene_actions():
	is_starting_scene = true
	start_scene()
#endregion


