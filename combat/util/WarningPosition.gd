class_name WarningTracker extends RefCounted
var total_duration : float
var time_passed : float
	
func _init(duration):
	total_duration = duration
	time_passed = 0

func get_remaining_duration() -> float:
	return total_duration - time_passed
