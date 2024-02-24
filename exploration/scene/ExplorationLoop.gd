extends Control

@export var current_floor_number : int = 0

@onready var floor_number_label : Label = $FloorNumberDisplay/FloorNumber

func _ready():
	increment_floor_number()

func _input(event : InputEvent):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		continue_exploration()
		get_viewport().set_input_as_handled()

func continue_exploration():
	# todo: trigger transition to combat state - incrementing floor number when returning.
	increment_floor_number()

func increment_floor_number():
	current_floor_number += 1
	floor_number_label.text = str(current_floor_number)
