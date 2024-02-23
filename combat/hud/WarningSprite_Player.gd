class_name WarningSprite_Player extends WarningSprite

@export var player : Player

func _ready():
	if player != null:
		_on_player_move(player.distance, player.lateral_position)
		player.player_move.connect(_on_player_move)

func _on_player_move(distance : Position.Ranges, lateral_position : Position.Direction):
	range_position = Vector2i(lateral_position, distance)
