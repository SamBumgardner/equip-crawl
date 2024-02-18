class_name AnimationManager extends Node

@export var enemySprite : AnimatedSprite2D

var possible_effects : Dictionary = {
	"enemy_move": _enemy_move
}

func _on_play_effect(name : String, _triggered_by : Object):
	possible_effects[name].call()
	pass

func _enemy_move():
	print("That enemy sure is wiggling!")
	pass # make em wiggle
