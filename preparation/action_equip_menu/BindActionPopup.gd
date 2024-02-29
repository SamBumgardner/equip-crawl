class_name BindActionPopup extends Control

signal action_bound(action : Action, input_index : Player.InputIndices)

@onready var action_badge : ActionBadge = $PanelContainer/MarginContainer/VBoxContainer/ActionBadge
var action : Action;

func set_action(new_action : Action):
	action_badge.set_action(new_action)
	action = new_action

func _on_revealed():
	grab_focus()

func _input(event):
	if visible:
		if  event.is_action_pressed("pause"):
			hide()
		for input in Player.PLAYER_INPUTS.keys():
			if event.is_action_pressed(input):
				action_bound.emit(action, Player.PLAYER_INPUTS[input])
				hide()
		get_viewport().set_input_as_handled()
