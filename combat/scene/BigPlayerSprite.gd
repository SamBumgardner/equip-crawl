class_name BigPlayerSprite extends AnimatedSprite2D

@onready var start_position : Vector2 = position

var current_tween : Tween

func reset_tweening():
	# reset position
	position = start_position
	modulate = Color.WHITE
	scale = Vector2.ONE
	
	if current_tween != null:
		current_tween.kill()
	
	current_tween = create_tween()
	return current_tween
