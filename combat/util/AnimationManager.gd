class_name AnimationManager extends Node

@export var enemy : Enemy
@export var player : Player
@export var enemySprite : BigEnemySprite
@export var player_sprite : BigPlayerSprite

var possible_effects : Dictionary = {
	"enemy_move": _enemy_move,
	"enemy_lunge": _enemy_lunge,
	"player_move_cw": _player_lateral_move.bind(MoveEffect.LateralDirection.CW),
	"player_move_ccw": _player_lateral_move.bind(MoveEffect.LateralDirection.CCW),
	"player_move_in": _player_vertical_move.bind(MoveEffect.RangeDirection.PLAYER_IN),
	"player_move_out": _player_vertical_move.bind(MoveEffect.RangeDirection.PLAYER_OUT)
}

func _ready():
	if enemy != null:
		enemy.visual_effect_triggered.connect(_on_play_effect)
	if player != null:
		player.visual_effect_triggered.connect(_on_play_effect)

func _on_play_effect(name : String, _triggered_by : Object):
	possible_effects[name].call()
	pass

func _enemy_move():
	var new_tween : Tween = enemySprite.reset_tweening()
	new_tween.tween_method(_movement_wiggle, 0, PI * 4, .25)

func _enemy_lunge():
	var new_tween : Tween = enemySprite.reset_tweening()
	new_tween.tween_method(_lunge_offset, 0, 30, .05)
	new_tween.tween_method(_lunge_offset, 30, 0, .2)

func _movement_wiggle(time_passed : float):
	enemySprite.position.y = enemySprite.start_position.y - sin(time_passed) * 10

func _lunge_offset(lunge_distance : float):
	var lunge_offset : Vector2
	match enemy.get_turn_direction_toward_player():
		MoveEffect.LateralDirection.NONE:
			lunge_offset = Vector2(0, lunge_distance)
		MoveEffect.LateralDirection.CW:
			lunge_offset = Vector2(lunge_distance, 0)
		MoveEffect.LateralDirection.CCW:
			lunge_offset = Vector2(-lunge_distance, 0)
		MoveEffect.LateralDirection.OPPOSITE:
			lunge_offset = Vector2(0, -lunge_distance)
	enemySprite.position = enemySprite.start_position + lunge_offset

func _player_lateral_move(direction : MoveEffect.LateralDirection):
	var new_tween : Tween = player_sprite.reset_tweening()
	new_tween.tween_method(_player_offset.bind(direction, 0), 0, 600, 0)
	new_tween.set_trans(Tween.TRANS_QUAD)
	new_tween.tween_method(_player_offset.bind(direction, 0), 600, 0, .2)

func _player_vertical_move(direction : MoveEffect.RangeDirection):
	var new_tween : Tween = player_sprite.reset_tweening()
	new_tween.tween_method(_player_offset.bind(0, direction), 0, 30, 0)
	new_tween.set_trans(Tween.TRANS_QUAD)
	new_tween.tween_method(_player_offset.bind(0, direction), 30, 0, .2)

func _player_offset(move_distance : float, 
		lateral_direction : MoveEffect.LateralDirection = MoveEffect.LateralDirection.NONE, 
		range_direction : MoveEffect.RangeDirection = MoveEffect.RangeDirection.NONE):
	var offset_coefficient : Vector2 = Vector2.ZERO
	
	match lateral_direction:
		MoveEffect.LateralDirection.CW:
			offset_coefficient.x += 1
		MoveEffect.LateralDirection.CCW:
			offset_coefficient.x -= 1
	
	match range_direction:
		MoveEffect.RangeDirection.PLAYER_IN:
			offset_coefficient.y += 1
		MoveEffect.RangeDirection.PLAYER_OUT:
			offset_coefficient.y -= 1
	
	player_sprite.position = player_sprite.start_position + Vector2(move_distance, move_distance) * offset_coefficient
		
