extends Sprite2D

@export var player : Player
@export var enemy : Enemy

@onready var player_icon : Sprite2D = $Player
@onready var enemy_icon : Sprite2D = $Enemy
var player_positions : Array
var warn_positions : Array
# angle we should rotate the icon for different directions
var player_rotations : Array[float] = [180, 270, 0, 90]
var enemy_rotations : Array[float] = [0, 90, 180, 270]

func _ready():
	if player != null:
		player.player_move.connect(_on_player_move)
		_init_player_positions()
		_on_player_move(player.distance, player.lateral_position)
	if enemy != null:
		enemy.enemy_turn.connect(_on_enemy_turn)
		enemy.threat_warning_new.connect(_on_threat_warning_new)
		_on_enemy_turn(enemy.facing)

func _init_player_positions():
	player_positions = [
		[$Node/North_Short, $Node/North_Medium, $Node/North_Long],
		[$Node/East_Short, $Node/East_Medium, $Node/East_Long],
		[$Node/South_Short, $Node/South_Medium, $Node/South_Long],
		[$Node/West_Short, $Node/West_Medium, $Node/West_Long]
	]
	warn_positions = [
		[$Node/North_Short/Warning, $Node/North_Medium/Warning, $Node/North_Long/Warning],
		[$Node/East_Short/Warning, $Node/East_Medium/Warning, $Node/East_Long/Warning],
		[$Node/South_Short/Warning, $Node/South_Medium/Warning, $Node/South_Long/Warning],
		[$Node/West_Short/Warning, $Node/West_Medium/Warning, $Node/West_Long/Warning]
	]

func _on_player_move(distance : Position.Ranges, lateral_position : Position.Direction):
	player_icon.reparent(player_positions[lateral_position][distance - 1])
	player_icon.position = Vector2.ZERO
	player_icon.rotation_degrees = player_rotations[lateral_position]

func _on_enemy_turn(direction : Position.Direction):
	enemy_icon.rotation_degrees = enemy_rotations[direction]

func _on_threat_warning_new(threatened_positions : Array, 
		remaining_time : float, triggering_action : Action):
	
	for possible_position in threatened_positions:
		var warn_sprite = warn_positions[possible_position.x][possible_position.y - 1] 
		if (warn_sprite is Warning):
			warn_sprite.add_warning(remaining_time)
	
	print("Received threat warning!")
