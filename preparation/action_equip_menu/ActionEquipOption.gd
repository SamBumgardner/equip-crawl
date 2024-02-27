class_name ActionEquipOption extends PanelContainer

signal equip_action_pressed(selected_action : Action)

@export var action : Action
@onready var action_badge : ActionBadge = $MarginContainer/VBoxContainer/ActionEquipOption

func _ready():
	if action != null:
		action_badge.set_action(action)


func _test():
	print("button press occurred")
	equip_action_pressed.emit(action)
