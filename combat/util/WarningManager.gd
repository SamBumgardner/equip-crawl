class_name WarningManager extends Node

@export var enemy : Enemy

var warning_positions : Array

func _init():
	warning_positions = []
	for lateral_position in range(0, 4):
		warning_positions.append([])
		for range_position in range(0, 3):
			warning_positions[lateral_position].append([])
	
func _ready():
	if enemy != null:
		enemy.threat_warning_new.connect(_on_threat_warning_new)

func get_warning_for_position(requested_position : Vector2i) -> WarningTracker:
	if requested_position.x >= 4 || requested_position.x < 0 \
			|| requested_position.y >= 4 || requested_position.y < 1:
		return null
	else:
		var warnings_for_position = warning_positions[requested_position.x][requested_position.y - 1]
		if !warnings_for_position.is_empty():
			return warnings_for_position[0]
		else:
			return null

func _process(delta):
	for lateral_i in range(warning_positions.size()):
		for range_i in range(warning_positions[lateral_i].size()):
			var warnings_for_position = warning_positions[lateral_i][range_i]
			if !warnings_for_position.is_empty():
				warning_positions[lateral_i][range_i] = _process_position_warnings(
					delta, warnings_for_position)

func _process_position_warnings(delta : float, 
		upcoming_warnings : Array) -> Array:
	for warning in upcoming_warnings:
		warning.time_passed += delta
	return upcoming_warnings.filter( 
		func(warning): return warning.time_passed < warning.total_duration)

func _on_threat_warning_new(threatened_positions : Array, 
		remaining_time : float, triggering_action : Action):
	for possible_position in threatened_positions:
		var position_warnings = warning_positions[possible_position.x][possible_position.y - 1]
		_add_warning(remaining_time, position_warnings)

func _add_warning(time_until_triggered : float, position_warnings : Array):
	var new_warning = WarningTracker.new(time_until_triggered)
	if position_warnings.is_empty():
		position_warnings.append(new_warning)
	elif (time_until_triggered < position_warnings[0].get_remaining_duration()):
		position_warnings.push_front(new_warning)
	else:
		position_warnings.push_back(new_warning)
