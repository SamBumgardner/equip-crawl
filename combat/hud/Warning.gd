class_name Warning extends Sprite2D

var upcoming_warnings : Array[WarningTracker]

func add_warning(time_until_triggered : float):
	var new_warning = WarningTracker.new(time_until_triggered)
	if upcoming_warnings.is_empty():
		upcoming_warnings.append(new_warning)
	elif (time_until_triggered < upcoming_warnings[0].get_remaining_duration()):
		upcoming_warnings.push_front(new_warning)
	else:
		upcoming_warnings.push_back(new_warning)

func _process(delta):
	if !upcoming_warnings.is_empty():
		# update graphic to modulate more red based on front upcoming warnings
		# decrement all warning timers according to delta
		# remove any warning timers that are expired
		for warning in upcoming_warnings:
			warning.time_passed += delta
		
		var next_warning = upcoming_warnings[0]
		modulate = Color.WHITE.lerp(Color.RED, next_warning.time_passed / next_warning.total_duration)
		
		upcoming_warnings = upcoming_warnings.filter( 
			func(warning): return warning.time_passed < warning.total_duration)
	else:
		modulate = Color.WHITE
	

class WarningTracker extends RefCounted:
	var total_duration : float
	var time_passed : float
	
	func _init(duration):
		total_duration = duration
		time_passed = 0
	
	func get_remaining_duration() -> float:
		return total_duration - time_passed
