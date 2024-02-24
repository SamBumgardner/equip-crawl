class_name CombatManager extends Node

signal combat_ended_sequence_begin()
signal combat_ended_sequence_finish()

@export var player : Player
@export var enemy  : Enemy

@onready var end_combat_timer : Timer = $EndCombatSequenceTimer

func _ready():
	player.combatant_defeated.connect(_on_combatant_defeated)
	enemy.combatant_defeated.connect(_on_combatant_defeated)
	end_combat_timer.timeout.connect(_on_combat_end_sequence_finished)

func _on_combatant_defeated(defeated : Combatant):
	print("\nGAMEPLAY MANAGER ANNOUNCEMENT:\n", defeated, " was defeated! Starting end sequence now\n")
	
	combat_ended_sequence_begin.emit(defeated is Enemy) # report victory or loss
	# For this version, we will just assume that all things finish their 
	# game over sequence in 3 seconds. This expects that everything's 
	# already been triggered by the thing that became defeated (sent visual events and whatever).
	end_combat_timer.start()

func _on_combat_end_sequence_finished():
	print("\nGAMEPLAY MANAGER ANNOUNCEMENT:\nend sequence finished. Cleaning up nodes")
	combat_ended_sequence_finish.emit()
	#todo: push event to Combat, Combat pushes out event to the void saying it's all done now.
	# Combat then just waits, transitioning thing can handle queue_free ing it.

func _process(delta : float):
	if !end_combat_timer.is_stopped() \
			and end_combat_timer.time_left <= end_combat_timer.wait_time - .75 \
			and Input.is_action_pressed("ui_cancel"):
		end_combat_timer.stop()
		_on_combat_end_sequence_finished()
