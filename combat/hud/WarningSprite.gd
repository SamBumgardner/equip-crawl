class_name WarningSprite extends Sprite2D

@export var warning_manager : WarningManager
@export var range_position : Vector2i

func initialize(warning_manager_in : WarningManager, range_position_in : Vector2i):
	warning_manager = warning_manager_in
	range_position = range_position_in

func _process(delta):
	if warning_manager != null:
		var next_warning = warning_manager.get_warning_for_position(range_position)
		if next_warning != null:
			modulate = Color.TRANSPARENT.lerp(Color.RED, next_warning.time_passed / next_warning.total_duration)
		else:
			modulate = Color.TRANSPARENT
	
