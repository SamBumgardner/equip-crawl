class_name CombatManager extends Node

@export var player : Player
@export var enemy  : Enemy

func _ready():
	player.combatant_defeated.connect(_on_combatant_defeated)
	enemy.combatant_defeated.connect(_on_combatant_defeated)
	$EndCombatSequenceTimer.timeout.connect(_on_combat_end_sequence_finished)

func _on_combatant_defeated(defeated : Combatant):
	print("\nGAMEPLAY MANAGER ANNOUNCEMENT:\n", defeated, " was defeated! Starting end sequence now\n")
	player.process_mode = Node.PROCESS_MODE_DISABLED
	enemy.process_mode = Node.PROCESS_MODE_DISABLED
	$EndCombatSequenceTimer.start()

func _on_combat_end_sequence_finished():
	print("\nGAMEPLAY MANAGER ANNOUNCEMENT:\nend sequence finished. Cleaning up nodes")
	player.queue_free()
	enemy.queue_free()
	self.queue_free()
