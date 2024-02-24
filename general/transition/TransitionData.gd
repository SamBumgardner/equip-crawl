class_name TransitionData extends RefCounted

var next_scene_name : String = ""

func _init(next_scene_name_in : String):
	next_scene_name = next_scene_name_in
	# let folks set up data about the player and everything else. 
	# This is also probably an okay thing to use for saving(?) since it's what persists between scenes
