class_name TransitionData extends RefCounted

var next_scene_name : String = ""
var exploration_data : ExplorationData

func _init(next_scene_name_in : String = "exploration", 
		exploration_data_in : ExplorationData = ExplorationData.new()):
	next_scene_name = next_scene_name_in
	exploration_data = exploration_data_in
	# let folks set up data about the player and everything else. 
	# This is also probably an okay thing to use for saving(?) since it's what persists between scenes
	
func _to_string():
	var result = ""
	result += "Transition Data:\n"
	result += "Next scene name: '%s'\n" % [next_scene_name]
	result += "  " + exploration_data.to_string() + "\n"
	return result


class ExplorationData:
	var floor_number : int = 0
	
	func _to_string():
		var result = "" 
		result += "Exploration data:\n"
		result += "floor number: %d\n" % [floor_number]
		return result
