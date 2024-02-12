class_name EffectiveRange extends RefCounted

var min_range : int
var max_range : int
var directions : int 

func _init(minRange : Position.Ranges = Position.Ranges.SHORT, 
		maxRange : Position.Ranges = Position.Ranges.SHORT, 
		initDirections = RangeDirections.ALL):
	min_range = minRange
	max_range = maxRange
	directions = initDirections

func _to_string():
	return "[%d,%d] " % [min_range, max_range] + RangeDirections.find_key(directions)

enum RangeDirections {
	FRONT = 0b0001,
	LEFT  = 0b0010,
	RIGHT = 0b0100,
	BACK  = 0b1000,
	ALL   = 0b1111,
}
