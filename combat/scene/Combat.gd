class_name Combat extends Control

signal combat_finished()
signal start_transition_out(transition_data : TransitionData, cleanup_callback : Callable)

@export var is_starting_scene : bool = false

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
	process_mode = Node.PROCESS_MODE_DISABLED
	if self == get_tree().current_scene || is_starting_scene:
		root_scene_actions()
	# set up event connections between everything
	combat_manager.combat_ended_sequence_begin.connect(_on_combat_ended_sequence_begin)
	combat_manager.combat_ended_sequence_finish.connect(_on_combat_ended_sequence_finish)
	
	for receiver in combat_finished_receivers:
		combat_finished.connect(receiver._on_combat_finished)

func _on_combat_ended_sequence_begin():
	combat_finished.emit()

func _on_combat_ended_sequence_finish():
	var transition_data = TransitionData.new("combat")
	start_transition_out.emit(transition_data, _cleanup_scene)

func _cleanup_scene():
	queue_free()

func init_scene(transitionData : TransitionData):
	pass # do stuff to make the transition smooth, persist data that needs to be persisted

func start_scene():
	process_mode = Node.PROCESS_MODE_INHERIT
	var hacky_tween : Tween = create_tween()
	hacky_tween.tween_interval(.05)
	hacky_tween.tween_callback($Warnings.show)

func root_scene_actions():
	is_starting_scene = true
	start_scene()
