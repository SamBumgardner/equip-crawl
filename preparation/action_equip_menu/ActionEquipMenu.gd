class_name ActionEquipMenu extends ColorRect

@onready var action_option_grid_container : GridContainer = $MarginContainer/ColorRect/VBoxContainer/PanelContainer/MarginContainer/ScrollContainer/MarginContainer/GridContainer
@onready var first_action_option : PanelContainer = $MarginContainer/ColorRect/VBoxContainer/PanelContainer/MarginContainer/ScrollContainer/MarginContainer/GridContainer/ActionEquipOption
@onready var finished_button : Button = $MarginContainer/ColorRect/FinishedButton
@onready var bind_action_popup : BindActionPopup = $BindActionPopup

func _ready():
	first_action_option.get_child(0).grab_focus()
	
	for action_option in action_option_grid_container.get_children():
		if action_option is ActionEquipOption:
			action_option.equip_action_pressed.connect(_on_equip_option_pressed)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		finished_button.grab_focus()

func _on_equip_option_pressed(action : Action):
	bind_action_popup.set_action(action)
	bind_action_popup.show()
