extends Sprite2D

@export var player : Player
@export var enemy : Enemy
@export var warning_manager : WarningManager

@onready var player_icon : Sprite2D = $Player
@onready var enemy_icon : Sprite2D = $Enemy
var player_positions : Array
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
		_on_enemy_turn(enemy.facing)

func _init_player_positions():
	player_positions = [
		[$Node/North_Short, $Node/North_Medium, $Node/North_Long],
		[$Node/East_Short, $Node/East_Medium, $Node/East_Long],
		[$Node/South_Short, $Node/South_Medium, $Node/South_Long],
		[$Node/West_Short, $Node/West_Medium, $Node/West_Long]
	]
	# initialize position-specific WarningSprites
	for x in range(player_positions.size()):
		for y in range(player_positions[x].size()):
			var warning_sprite = player_positions[x][y].get_children()[0] as WarningSprite
			warning_sprite.initialize(warning_manager, Vector2i(x, y + 1))

func _on_player_move(distance : Position.Ranges, lateral_position : Position.Direction):
	player_icon.reparent(player_positions[lateral_position][distance - 1])
	player_icon.position = Vector2.ZERO
	player_icon.rotation_degrees = player_rotations[lateral_position]

func _on_enemy_turn(direction : Position.Direction):
	enemy_icon.rotation_degrees = enemy_rotations[direction]

func _on_combat_finished():
	create_tween().tween_property(self, "modulate", Color.TRANSPARENT, 1.5)
