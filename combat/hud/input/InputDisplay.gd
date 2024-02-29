class_name InputDisplay extends Control

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
	if player != null:
		player.action_used.connect(_on_player_action_used)
		_initalize_action_buttons(player.available_actions)
	else:
		var empty_actions_array : Array[Action] = []
		for display in button_displays:
			empty_actions_array.append(null)
		_initalize_action_buttons(empty_actions_array)

func _initalize_action_buttons(actions_array : Array[Action]):
	for i in range(actions_array.size()):
		var action = actions_array[i]
		_on_player_action_changed(i, action)

func _on_player_action_changed(input : Player.InputIndices, action : Action):
	if action != null:
		button_displays[input].update_icon(action.icon)
		button_displays[input].update_count(action.remaining_uses)
	else:
		button_displays[input].empty_display()

func _on_player_action_used(input : Player.InputIndices, remaining_uses : int):
	button_displays[input].update_count(remaining_uses)
