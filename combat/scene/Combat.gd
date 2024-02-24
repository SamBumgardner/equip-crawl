class_name Combat extends Control

signal combat_finished()
signal ready_transition_out()

@onready var combat_manager : CombatManager = $CombatManager

@onready var combat_finished_receivers = [
		$CastBar_Enemy, 
		$CastBar_Player,
		$WarningManager,
		$Player,
		$Enemy,
		$Radar
	]

func _ready():
	# set up event connections between everything
	combat_manager.combat_ended_sequence_begin.connect(_on_combat_ended_sequence_begin)
	
	for receiver in combat_finished_receivers:
		combat_finished.connect(receiver._on_combat_finished)

func _on_combat_ended_sequence_begin():
	combat_finished.emit()
