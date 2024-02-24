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
	#todo: emit signal saying let's begin game-over-ing
	# For this version, we can just have a rule that all things finish their 
	# game over sequence in 3 seconds. This just assumes that everything's 
	# already been triggered by the thing that became defeated (sent visual events and whatever).
	$EndCombatSequenceTimer.start()

func _on_combat_end_sequence_finished():
	print("\nGAMEPLAY MANAGER ANNOUNCEMENT:\nend sequence finished. Cleaning up nodes")
	#todo: push event to Combat, Combat pushes out event to the void saying it's all done now.
	# Combat then just waits, transitioning thing can handle queue_free ing it.
