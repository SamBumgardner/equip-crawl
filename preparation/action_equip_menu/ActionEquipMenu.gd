class_name ActionEquipMenu extends ColorRect

const EQUIP_OPTION_PRELOAD = preload("res://preparation/action_equip_menu/ActionEquipOption.tscn")

signal loadout_selection_done(player_actions : Array[Action])

@onready var action_option_grid_container : GridContainer = $MarginContainer/ColorRect/VBoxContainer/PanelContainer/MarginContainer/ScrollContainer/MarginContainer/GridContainer
@onready var finished_button : Button = $MarginContainer/ColorRect/FinishedButton
@onready var bind_action_popup : BindActionPopup = $BindActionPopup
@onready var input_display : InputDisplay = $MarginContainer/ColorRect/InputDisplay

@onready var action_option_buttons : Array[Node] = action_option_grid_container.get_children()

var current_bound_actions : Array[Action] = []

func _ready():
	if get_tree().current_scene == self:
		set_possible_actions([Action_PlayerAttack.new()], [])
	
	for i in range(Player.InputIndices.size()):
		current_bound_actions.append(null)
	action_option_grid_container.get_child(0).get_child(0).grab_focus()
	
	bind_action_popup.action_bound.connect(_on_action_bound)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		finished_button.grab_focus()

func set_possible_actions(possible_actions : Array[Action], equipped_actions : Array[Action]):
	for child in action_option_grid_container.get_children():
		child.queue_free()
	action_option_buttons = []
	
	for possible_action in possible_actions:
		var equip_option : ActionEquipOption = EQUIP_OPTION_PRELOAD.instantiate()
		equip_option.initialize(possible_action)
		action_option_grid_container.add_child(equip_option)
		equip_option.equip_action_pressed.connect(_on_equip_option_pressed)
		action_option_buttons.append(equip_option)
	
	current_bound_actions = equipped_actions
	for i in range(current_bound_actions.size()):
		_on_action_bound(current_bound_actions[i], i)


func _on_equip_option_pressed(action : Action):
	_unbind_action(action)
	bind_action_popup.set_action(action)
	bind_action_popup.show()

func _unbind_action(action : Action):
	if action != null:
		get_action_option(action).equipped = false
		for input_index in Player.InputIndices.values():
			if current_bound_actions[input_index] == action:
				current_bound_actions[input_index] = null
				input_display._on_player_action_changed(input_index, null)

func _on_action_bound(action : Action, input_index : Player.InputIndices):
	_unbind_action(current_bound_actions[input_index])
	input_display._on_player_action_changed(input_index, action)
	if action != null:
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
	hide()

func _on_visibility_changed():
	if visible && action_option_grid_container.get_children().size() > 0:
		action_option_grid_container.get_child(0).get_child(0).grab_focus()
