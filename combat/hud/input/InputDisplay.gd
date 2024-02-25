extends Control

@export var player : Player

# Ordered to match Player.InputIndices
@onready var button_displays : Array[ButtonDisplay] = [
	$Directional_Buttons/Direction_Up,
	$Directional_Buttons/Direction_Right,
	$Directional_Buttons/Direction_Down,
	$Directional_Buttons/Direction_Left,
	$Face_Buttons/Button_0_0,
	$Face_Buttons/Button_1_0,
	$Face_Buttons/Button_0_1,
	$Face_Buttons/Button_1_1
]

func _ready():
	# temp
	button_displays[Player.InputIndices.UP].update_icon(load("res://art/input_display/action_icons/move_forward.png"))
	button_displays[Player.InputIndices.RIGHT].update_icon(load("res://art/input_display/action_icons/move_right.png"))
	button_displays[Player.InputIndices.DOWN].update_icon(load("res://art/input_display/action_icons/move_backward.png"))
	button_displays[Player.InputIndices.LEFT].update_icon(load("res://art/input_display/action_icons/move_left.png"))

	if player != null:
		player.action_used.connect(_on_player_action_used)
		_initalize_action_buttons()

func _initalize_action_buttons():
	for i in range(player.available_actions.size()):
		var action = player.available_actions[i]
		_on_player_action_changed(i, action)

func _on_player_action_changed(input : Player.InputIndices, action : Action):
	if action != null:
		button_displays[input].update_icon(action.icon)
		button_displays[input].update_count(action.remaining_uses)
	else:
		button_displays[input].empty_display()

func _on_player_action_used(input : Player.InputIndices, remaining_uses : int):
	button_displays[input].update_count(remaining_uses)
