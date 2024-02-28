class_name ActionEquipMenu extends ColorRect

signal loadout_selection_done(player_actions : Array[Action])

@onready var action_option_grid_container : GridContainer = $MarginContainer/ColorRect/VBoxContainer/PanelContainer/MarginContainer/ScrollContainer/MarginContainer/GridContainer
@onready var first_action_option : PanelContainer = $MarginContainer/ColorRect/VBoxContainer/PanelContainer/MarginContainer/ScrollContainer/MarginContainer/GridContainer/ActionEquipOption
@onready var finished_button : Button = $MarginContainer/ColorRect/FinishedButton
@onready var bind_action_popup : BindActionPopup = $BindActionPopup
@onready var input_display : InputDisplay = $MarginContainer/ColorRect/InputDisplay

@onready var action_option_buttons : Array[Node] = action_option_grid_container.get_children()

var current_bound_actions : Array[Action] = []

func _ready():
	for i in range(Player.InputIndices.size()):
		current_bound_actions.append(null)
	first_action_option.get_child(0).grab_focus()
	
	for action_option in action_option_buttons:
		if action_option is ActionEquipOption:
			action_option.equip_action_pressed.connect(_on_equip_option_pressed)
	
	bind_action_popup.action_bound.connect(_on_action_bound)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		finished_button.grab_focus()

func _on_equip_option_pressed(action : Action):
	_unbind_action(action)
	bind_action_popup.set_action(action)
	bind_action_popup.show()

func _unbind_action(action : Action):
	get_action_option(action).equipped = false
	for input_index in Player.InputIndices.values():
		if current_bound_actions[input_index] == action:
			current_bound_actions[input_index] = null
			input_display._on_player_action_changed(input_index, null)

func _on_action_bound(action : Action, input_index : Player.InputIndices):
	input_display._on_player_action_changed(input_index, action)
	get_action_option(action).equipped = true
	current_bound_actions[input_index] = action
	bind_action_popup.hide()

func get_action_option(action : Action) -> ActionEquipOption:
	for action_option in action_option_buttons:
		if action_option.action == action:
			return action_option
	return null

func _on_finished_button_pressed():
	loadout_selection_done.emit(current_bound_actions)
