class_name BindActionPopup extends Control

@onready var action_badge : ActionBadge = $PanelContainer/MarginContainer/VBoxContainer/ActionBadge

func set_action(action : Action):
	action_badge.set_action(action)
