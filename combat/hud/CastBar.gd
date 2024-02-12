class_name CastBar extends ProgressBar

@export var combatant : Combatant

var timer : Timer
var current_state : CombatantStates.States = CombatantStates.States.IDLE

func _ready():
	timer = $Timer
	if combatant != null:
		combatant.state_changed.connect(_on_combatant_state_change)

func _on_combatant_state_change(new_state : CombatantStates.States, duration : float):
	match new_state:
		CombatantStates.States.IDLE:
			pass # could start hiding it - fade-out or something that won't be obtrusive if they start again immediately
		CombatantStates.States.CHARGE:
			show()
			modulate = Color.WHITE
			timer.start(duration)
		CombatantStates.States.ACT:
			pass # fire particle effects or something fun to show the cast completed.
		CombatantStates.States.RECOVER:
			show()
			modulate = Color.GRAY
			timer.start(duration)
	current_state = new_state

func _process(delta):
	if (!timer.is_stopped()):
		value = (timer.wait_time - timer.time_left) / timer.wait_time
	else:
		value = 1
	if current_state == CombatantStates.States.RECOVER || current_state == CombatantStates.States.IDLE: # hacky, avoids visual bugs that make stuff appear incorrectly
		value = 1 - value
	value *= 100
	
