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

var received_transition_data : TransitionData
var victory : bool = false;

func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED
	if self == get_tree().current_scene || is_starting_scene:
		root_scene_actions()
	# set up event connections between everything
	combat_manager.combat_ended_sequence_begin.connect(_on_combat_ended_sequence_begin)
	combat_manager.combat_ended_sequence_finish.connect(_on_combat_ended_sequence_finish)
	
	for receiver in combat_finished_receivers:
		combat_finished.connect(receiver._on_combat_finished)

func _on_combat_ended_sequence_begin(player_won : bool):
	victory = player_won
	combat_finished.emit()

func _on_combat_ended_sequence_finish():
	_signal_transition_out()

#region State Transition Support
func _signal_transition_out():
	if received_transition_data == null:
		received_transition_data = TransitionData.new()
	
	if victory:
		received_transition_data.next_scene_name = Transition.EXPLORATION
	else:
		received_transition_data.next_scene_name = Transition.DEFEATED
	
	var player : Player = $Player
	received_transition_data.player_data.max_health = player.max_health
	received_transition_data.player_data.current_health = player.health
	
	#todo: update transition_data with new values
	start_transition_out.emit(received_transition_data, _cleanup_scene)

func _cleanup_scene():
	queue_free()

func init_scene(transitionData : TransitionData):
	received_transition_data = transitionData
	var player : Player = $Player
	player.max_health = received_transition_data.player_data.max_health
	player.health = received_transition_data.player_data.current_health
	pass # do stuff to make the transition smooth, persist data that needs to be persisted

func start_scene():
	process_mode = Node.PROCESS_MODE_INHERIT
	# Turning on processing and showing warnings on the same frame makes them appear
	#  all at once non-transparent for one frame. Could be solved by making the warnings not show
	#  by default, but this is a bit quicker to implement for now.
	var hacky_tween : Tween = create_tween()
	hacky_tween.tween_interval(.05)
	hacky_tween.tween_callback($Warnings.show)

func root_scene_actions():
	is_starting_scene = true
	start_scene()
#endregion
