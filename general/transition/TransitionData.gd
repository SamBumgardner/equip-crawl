class_name TransitionData extends RefCounted

static var PLAYER_ACTIONS : Array[Action] = [
		Action_PlayerMoveForward.new(),
		Action_PlayerMoveRight.new(),
		Action_PlayerMoveBackward.new(),
		Action_PlayerMoveLeft.new(),
		Action_PlayerAttack.new(),
		Action_PlayerPowerAttack.new(),
		Action_PlayerLeap.new(),
		Action_PlayerShortbow.new(),
		Action_PlayerLongbow.new(),
		Action_PlayerKick.new(),
		Action_PlayerHammer.new(),
		Action_PlayerBackflipKick.new(),
		Action_PlayerDagger.new(),
	]

var next_scene_name : String = ""
var exploration_data : ExplorationData
var player_data : PlayerData
var progression_data : ProgressionData
var combat_data : CombatData

func _init(next_scene_name_in : String = "exploration", 
		exploration_data_in : ExplorationData = ExplorationData.new(),
		player_data_in : PlayerData = PlayerData.new(),
		progression_data_in : ProgressionData = ProgressionData.new(),
		combat_data_in : CombatData = CombatData.new()):
	next_scene_name = next_scene_name_in
	exploration_data = exploration_data_in
	player_data = player_data_in
	progression_data = progression_data_in
	combat_data = combat_data_in
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
		TransitionData.PLAYER_ACTIONS[0],
		TransitionData.PLAYER_ACTIONS[1],
		TransitionData.PLAYER_ACTIONS[2],
		TransitionData.PLAYER_ACTIONS[3],
		null,
		null,
		TransitionData.PLAYER_ACTIONS[4],
		TransitionData.PLAYER_ACTIONS[5],
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
				action.remaining_uses = action.max_uses
	
	func assign_action_combat_targets(player : Player, enemy : Enemy):
		for action in current_actions:
			if action != null:
				action.player = player
				action.enemy = enemy


class ProgressionData:
	var unlocked_actions : Array[Action] = TransitionData.PLAYER_ACTIONS

	func _to_string():
		var result = ""
		result += "Progression data:\n"
		result += "  unlocked actions: " + str(unlocked_actions)
		return result


class CombatData:
	var enemy_data : EnemyData = preload("res://combat/enemy_data/onion/onion_basic/onion_basic.tres")
	#var enemy_data : EnemyData = preload("res://combat/enemy_data/skeleton_spear/skeleton_spear.tres")
