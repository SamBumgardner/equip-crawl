class_name ActionEquipMenu extends ColorRect

@onready var first_action_option : PanelContainer = $MarginContainer/ColorRect/VBoxContainer/PanelContainer/MarginContainer/ScrollContainer/MarginContainer/GridContainer/ActionEquipOption
@onready var finished_button : Button = $MarginContainer/ColorRect/FinishedButton

func _ready():
	first_action_option.get_child(0)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		finished_button.grab_focus()
