class_name WarningSprite_Player extends WarningSprite

@export var player : Player
@export var position_offset : Vector2i = Vector2i.ZERO

func _ready():
	if player != null:
		_on_player_move(player.distance, player.lateral_position)
		player.player_move.connect(_on_player_move)

func _on_player_move(distance : Position.Ranges, lateral_position : Position.Direction):
	range_position = Vector2i((lateral_position + position_offset.x + 4) % 4, distance + position_offset.y)
