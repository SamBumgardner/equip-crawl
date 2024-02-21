class_name AnimationManager extends Node

@export var enemy : Enemy
@export var enemySprite : BigEnemySprite

var possible_effects : Dictionary = {
	"enemy_move": _enemy_move,
	"enemy_lunge": _enemy_lunge
}

func _ready():
	if enemy != null:
		enemy.visual_effect_triggered.connect(_on_play_effect)

func _on_play_effect(name : String, _triggered_by : Object):
	possible_effects[name].call()
	pass

func _enemy_move():
	var new_tween : Tween = enemySprite.reset_tweening()
	new_tween.tween_method(_movement_wiggle, 0, PI * 4, .25)

func _enemy_lunge():
	var new_tween : Tween = enemySprite.reset_tweening()
	#new_tween.tween_property(enemySprite, "position", enemySprite.start_position + Vector2(0, 30), .05)
	#new_tween.tween_property(enemySprite, "position", enemySprite.start_position, .2)
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
