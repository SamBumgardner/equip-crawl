class_name AnimationManager extends Node

@export var enemy : Enemy
@export var player : Player
@export var enemySprite : BigEnemySprite
@export var player_sprite : BigPlayerSprite

@onready var possible_effects : Dictionary = {
	"enemy_move": _enemy_move,
	"enemy_lunge": _enemy_lunge,
	"enemy_hurt": _combatant_modulate.bind(enemySprite, Color.DARK_RED),
	"enemy_block": _combatant_modulate.bind(enemySprite, Color.DIM_GRAY),
	"player_move_cw": _player_lateral_move.bind(MoveEffect.LateralDirection.CW),
	"player_move_ccw": _player_lateral_move.bind(MoveEffect.LateralDirection.CCW),
	"player_move_in": _player_vertical_move.bind(MoveEffect.RangeDirection.PLAYER_IN),
	"player_move_out": _player_vertical_move.bind(MoveEffect.RangeDirection.PLAYER_OUT),
	"player_knockback": _player_knockback,
	"player_bounce_forward": _player_bounce_forward,
	"player_charge": _player_charge,
	"player_slash": _player_slash,
	"player_hurt": _combatant_modulate.bind(player_sprite, Color.DARK_RED),
	"player_block": _combatant_modulate.bind(player_sprite, Color.DIM_GRAY)
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
	new_tween.tween_method(_movement_wiggle, 0, 10, .1)
	new_tween.tween_method(_movement_wiggle, 10, -10, .1)
	new_tween.tween_method(_movement_wiggle, -10, 0, .1)

func _enemy_lunge():
	var new_tween : Tween = enemySprite.reset_tweening()
	new_tween.tween_method(_lunge_offset, 0, 30, .05)
	new_tween.tween_method(_lunge_offset, 30, 0, .2)

func _movement_wiggle(distance : float):
	enemySprite.position.y = enemySprite.start_position.y - distance

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
	new_tween.tween_method(_player_offset.bind(direction, 0), 0, 100, 0)
	new_tween.parallel().tween_property(player_sprite, "modulate", Color.TRANSPARENT, 0)
	new_tween.set_trans(Tween.TRANS_QUAD)
	new_tween.tween_method(_player_offset.bind(direction, 0), 100, 0, .3)
	new_tween.parallel().tween_property(player_sprite, "modulate", Color.WHITE, .3)

func _player_vertical_move(direction : MoveEffect.RangeDirection):
	var new_tween : Tween = player_sprite.reset_tweening()
	new_tween.tween_method(_player_offset.bind(0, direction), 0, 30, 0)
	new_tween.set_trans(Tween.TRANS_QUAD)
	new_tween.tween_method(_player_offset.bind(0, direction), 30, 0, .2)

func _player_knockback():
	var new_tween : Tween = player_sprite.reset_tweening()
	new_tween.tween_method(_player_offset.bind(0, 1), 0, 60, .1)
	new_tween.set_trans(Tween.TRANS_QUAD)
	new_tween.tween_method(_player_offset.bind(0, 1), 60, 0, .4)
	

func _player_offset(move_distance : float, 
		lateral_direction : MoveEffect.LateralDirection = MoveEffect.LateralDirection.NONE, 
		range_direction : MoveEffect.RangeDirection = MoveEffect.RangeDirection.NONE):
	var offset_coefficient : Vector2 = Vector2.ZERO
	
	match lateral_direction:
		MoveEffect.LateralDirection.CW:
			offset_coefficient.x += 1
		MoveEffect.LateralDirection.CCW:
			offset_coefficient.x -= 1
	
	if range_direction != MoveEffect.RangeDirection.NONE:
		offset_coefficient.y += 1
	
	player_sprite.position = player_sprite.start_position + Vector2(move_distance, move_distance) * offset_coefficient

func _player_bounce_forward():
	var new_tween : Tween = player_sprite.reset_tweening()
	new_tween.tween_method(_player_offset.bind(0, MoveEffect.RangeDirection.PLAYER_OUT), 0, 30, .05)
	new_tween.tween_method(_player_offset.bind(0, MoveEffect.RangeDirection.PLAYER_OUT), 30, -30, .05)
	new_tween.tween_method(_player_offset.bind(0, MoveEffect.RangeDirection.PLAYER_OUT), -30, 0, .2)

func _player_charge():
	var charge_wiggle_frequency = .02
	var charge_wiggle_distance = 20
	var charge_wiggle_cycles = 4
	
	var new_tween : Tween = player_sprite.reset_tweening()
	new_tween.tween_method(_player_offset.bind(0, MoveEffect.RangeDirection.PLAYER_OUT), 0, 30, .05)
	new_tween.parallel().tween_property(player_sprite, "scale", Vector2(.85, 1), .05)
	new_tween.tween_method(_player_offset.bind(1, 0), 0, charge_wiggle_distance, .05)
	for i in range(charge_wiggle_cycles):
		new_tween.tween_method(_player_offset.bind(1, 0), charge_wiggle_distance, -charge_wiggle_distance, charge_wiggle_frequency)
		new_tween.tween_method(_player_offset.bind(-1, 0), charge_wiggle_distance, -charge_wiggle_distance, charge_wiggle_frequency)
	new_tween.tween_method(_player_offset.bind(1,0), charge_wiggle_distance, 0, .1)

func _player_slash():
	var slash_distance = 50
	var hang_time = .1
	var slash_time = .05
	var recover_time = .5
	
	var new_tween : Tween = player_sprite.reset_tweening()
	new_tween.tween_method(_player_offset.bind(1, -1), 0, slash_distance, 0)
	new_tween.tween_interval(hang_time)
	new_tween.tween_method(_player_offset.bind(1, -1), slash_distance, -slash_distance, slash_time)
	new_tween.tween_method(_player_offset.bind(1, -1), -slash_distance, 0, recover_time)

func _combatant_modulate(combatant_sprite, start_color : Color):
	var new_tween : Tween = combatant_sprite.reset_tweening()
	new_tween.tween_property(combatant_sprite, "modulate", start_color, 0)
	new_tween.tween_property(combatant_sprite, "modulate", Color.WHITE, .2)
