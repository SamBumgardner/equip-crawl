class_name ActionEquipOption extends PanelContainer

signal equip_action_pressed(selected_action : Action)

@export var action : Action
@onready var action_badge : ActionBadge = $MarginContainer/VBoxContainer/ActionEquipOption
@onready var is_equipped_sprite = $IsEquipped

var equipped : bool:
	set(value):
		equipped = value
		is_equipped_sprite.visible = value

func initialize(action_in : Action):
	action = action_in

func _ready():
	if action != null:
		action_badge.set_action(action)

func _test():
	equip_action_pressed.emit(action)
