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

enum RangeDirections {
	FRONT = 0x0001,
	LEFT  = 0x0010,
	RIGHT = 0x0100,
	BACK  = 0x1000,
	ALL   = 0x1111,
}
