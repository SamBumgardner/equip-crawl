class_name HealthBar extends ProgressBar

@export var combatant : Combatant

func _ready():
	if combatant != null:
		combatant.health_changed.connect(_on_health_changed)
		_on_health_changed(combatant.health, combatant.max_health)

func _on_health_changed(health : float, max_health : float):
	value = health / max_health * 100
