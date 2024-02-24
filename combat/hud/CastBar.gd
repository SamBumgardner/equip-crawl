class_name CastBar extends VBoxContainer

@export var combatant : Combatant

@onready var action_name_label : Label = $NameContainer/ActionName
@onready var cast_progress_bar : CastProgress = $CastProgress

func _ready():
	cast_progress_bar.initialize(combatant)
	action_name_label.text = ""
	if (combatant != null):
		combatant.state_changed.connect(_on_combatant_state_change)
	hide()

func _on_combatant_state_change(new_state : CombatantStates.States, duration : float,
		current_action : Action):
	visible = current_action.display_cast_bar
	action_name_label.text = current_action.name
	if new_state == CombatantStates.States.IDLE:
		hide()
	# add logic here to selectively fade out stuff

func _on_combat_finished():
	cast_progress_bar.process_mode =Node.PROCESS_MODE_DISABLED
	var fade_out_tween = create_tween()
	fade_out_tween.tween_property(self, "modulate", Color.TRANSPARENT, 1.5)
