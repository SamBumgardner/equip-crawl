class_name BigEnemySprite extends AnimatedSprite2D

@export var player : Player
@export var enemy : Enemy

@onready var start_position : Vector2 = position

# angle we should rotate the icon for different directions
var enemy_sizes : Array[Vector2] = [Vector2(1.5, 1.5), Vector2(1, 1), Vector2(.75, .75)]

var current_tween : Tween

func _ready():
	if player != null:
		player.player_move.connect(_on_player_move)
		_on_player_move(player.distance, player.lateral_position)
	if enemy != null:
		enemy.enemy_turn.connect(_on_enemy_turn)
		_on_enemy_turn(enemy.facing)

func initialize_data(enemy_data : EnemyData):
	sprite_frames = enemy_data.animated_sprite

func _on_player_move(distance : Position.Ranges, lateral_position : Position.Direction):
	scale = enemy_sizes[distance - 1]
	_play_facing_animation(lateral_position, enemy.facing)

func _on_enemy_turn(direction : Position.Direction):
	_play_facing_animation(player.lateral_position, direction)

func _play_facing_animation(player_lateral_position, enemy_facing):
	var position_relative_to_enemy = (player_lateral_position - enemy_facing + 4) % 4 
	var side_of_enemy_player_sees : String = "default"
	match position_relative_to_enemy:
		0: side_of_enemy_player_sees = "front"
		1: side_of_enemy_player_sees = "left"
		2: side_of_enemy_player_sees = "back"
		3: side_of_enemy_player_sees = "right"
	play(side_of_enemy_player_sees)

func reset_tweening(): # TODO: tag system for visual effects to determine what should be reset and what should be retained.
	# reset position
	position = start_position
	modulate = Color.WHITE
	
	if current_tween != null:
		current_tween.kill()
	
	current_tween = create_tween()
	return current_tween
