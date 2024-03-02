extends Control

signal start_transition_out(transition_data : TransitionData, cleanup_callback : Callable)

@export var is_starting_scene : bool = false
@export var current_floor_number : int = 0

@onready var floor_number_label : Label = $FloorContentsDisplay/FloorNumber

var discovered_action : Action

var enemy_list = [
	preload("res://combat/enemy_data/skeleton_spear/skeleton_spear.tres"),
	preload("res://combat/enemy_data/onion/onion_basic/onion_basic.tres"),
	preload("res://combat/enemy_data/onion/onion_red/onion_red.tres"),
	preload("res://combat/enemy_data/onion/onion_green/onion_green.tres"),
]

var received_transition_data : TransitionData

func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED
	if self == get_tree().current_scene || is_starting_scene:
		root_scene_actions()
	increment_floor_number()
	$FloorContentsDisplay/MarginContainer/OpenEquipMenuButton.grab_focus()

func _on_begin_button_pressed():
	continue_exploration()

func continue_exploration():
	_signal_transition_out()

func increment_floor_number():
	current_floor_number += 1
	floor_number_label.text = str(current_floor_number)

func _on_open_equip_menu_button_pressed():
	$ActionEquipMenu.show()
	$FloorContentsDisplay/MarginContainer/OpenEquipMenuButton.focus_mode = FOCUS_NONE
	$FooterContainer/DescendButton.focus_mode = FOCUS_NONE

func _on_loadout_selection_done(player_actions):
	if received_transition_data == null:
		received_transition_data = TransitionData.new()
	received_transition_data.player_data.current_actions = player_actions
	$FloorContentsDisplay/MarginContainer/OpenEquipMenuButton.focus_mode = FOCUS_ALL
	$FooterContainer/DescendButton.focus_mode = FOCUS_ALL
	$FloorContentsDisplay/MarginContainer/OpenEquipMenuButton.grab_focus()

#region State Transition Support
func _signal_transition_out():
	if received_transition_data == null:
		received_transition_data = TransitionData.new()
	received_transition_data.next_scene_name = Transition.COMBAT
	received_transition_data.exploration_data.floor_number = current_floor_number
	received_transition_data.combat_data.enemy_data = enemy_list[current_floor_number % enemy_list.size()] 
	start_transition_out.emit(received_transition_data, _cleanup_scene)
	# need to stop own input processing:
	process_mode = Node.PROCESS_MODE_DISABLED

func _cleanup_scene():
	queue_free()

func init_scene(transitionData : TransitionData):
	received_transition_data = transitionData
	
	print(received_transition_data.player_data.current_actions)
	current_floor_number = received_transition_data.exploration_data.floor_number
	discovered_action = (TransitionData.PLAYER_ACTIONS.pick_random() as Action).duplicate()
	$FloorContentsDisplay/Discovery/ActionBadge.set_action(discovered_action)
	received_transition_data.player_data.available_actions.append(discovered_action)
	received_transition_data.player_data.remove_empty_actions()
	print(received_transition_data.player_data.current_actions)

func start_scene():
	if received_transition_data == null:
		received_transition_data = TransitionData.new()
	$ActionEquipMenu.set_possible_actions(
		received_transition_data.player_data.available_actions, 
		received_transition_data.player_data.current_actions)
	process_mode = Node.PROCESS_MODE_INHERIT

func root_scene_actions():
	is_starting_scene = true
	init_scene(TransitionData.new())
	start_scene()
#endregion
