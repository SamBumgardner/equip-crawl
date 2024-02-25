class_name TransitionData extends RefCounted

var next_scene_name : String = ""
var exploration_data : ExplorationData
var player_data : PlayerData

func _init(next_scene_name_in : String = "exploration", 
		exploration_data_in : ExplorationData = ExplorationData.new(),
		player_data_in : PlayerData = PlayerData.new()):
	next_scene_name = next_scene_name_in
	exploration_data = exploration_data_in
	player_data = player_data_in
	# let folks set up data about the player and everything else. 
	# This is also probably an okay thing to use for saving(?) since it's what persists between scenes
	
func _to_string():
	var result = ""
	result += "Transition Data:\n"
	result += "Next scene name: '%s'\n" % [next_scene_name]
	result += exploration_data.to_string()
	result += player_data.to_string()
	result += "\n"
	return result

class ExplorationData:
	var floor_number : int = 0
	
	func _to_string():
		var result = "" 
		result += "Exploration data:\n"
		result += "  floor number: %d\n" % [floor_number]
		return result
	
	func reset():
		floor_number = 0

class PlayerData:
	var max_health : int = 10
	var current_health : int = 10
	var current_actions : Array[Action] = [
	Action_PlayerMoveForward.new(),
	Action_PlayerMoveRight.new(),
	Action_PlayerMoveBackward.new(),
	Action_PlayerMoveLeft.new(),
	null,
	null,
	Action_PlayerAttack.new(),
	Action_PlayerPowerAttack.new(),
]

	func _to_string():
		var result = ""
		result += "Player data:\n"
		result += "  max health: %d\n" % [max_health]
		result += "  current health: %d\n" % [current_health]
		return result
	
	func restore():
		current_health = max_health
		for action in current_actions:
			if action != null:
				action.remaining_uses = 10
