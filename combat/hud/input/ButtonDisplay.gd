class_name ButtonDisplay extends TextureRect

const unpressed_color = Color.WHITE
const pressed_color = Color.DIM_GRAY
const normal_alpha = 1;
const exhausted_alpha = .5;

@export var input_action_name : String = ""

@onready var uses_remaining_label : Label = $UsesRemaining
@onready var action_icon : TextureRect = $ActionIcon

var is_exhausted : bool = false

func _process(delta):
	modulate_button()

func update_icon(new_texture : Texture2D):
	uses_remaining_label.show()
	action_icon.show()
	action_icon.texture = new_texture

func update_count(new_count : int):
	is_exhausted = new_count <= 0
	uses_remaining_label.show()
	action_icon.show()
	uses_remaining_label.text = str(min(new_count, 99))
	modulate_button()

func empty_display():
	is_exhausted = true
	uses_remaining_label.hide()
	action_icon.hide()
	modulate_button()

func modulate_button():
	if Input.is_action_pressed(input_action_name):
		modulate = Color(pressed_color, exhausted_alpha if is_exhausted else normal_alpha)
	else:
		modulate = Color(unpressed_color, exhausted_alpha if is_exhausted else normal_alpha)
