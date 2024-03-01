class_name HealthBar extends MarginContainer

@export var combatant : Combatant
@export var health_bar_color : Color = Color.RED

@onready var chase_bar : ProgressBar = $ChaseBar
@onready var value_bar : ProgressBar = $ChaseBar/ValueBar
@onready var label : Label = $Label
@onready var start_position : Vector2 = position

var chase_tween : Tween
var text_shake_tween : Tween

func _ready():
	value_bar.self_modulate = health_bar_color
	if combatant != null:
		combatant.health_changed.connect(_on_health_changed)
		_on_health_changed(combatant.health, combatant.max_health, true)

func _on_health_changed(health : float, max_health : float, is_setup : bool = false):
	chase_bar.value = value_bar.value # Comment this out if you want to have the orange bar keep extending as you do multiple hits.
	label.text = "%d/%d" % [health, max_health]
	value_bar.value = health / max_health * 100
	
	if is_setup:
		chase_bar.value = value_bar.value
	else:
		if chase_tween != null and chase_tween.is_valid():
			chase_tween.stop()
		chase_tween = create_tween()
		chase_tween.tween_interval(.25)
		chase_tween.set_ease(Tween.EASE_IN)
		chase_tween.set_trans(Tween.TRANS_CUBIC)
		chase_tween.tween_property(chase_bar, "value", value_bar.value, 2)
	
		if text_shake_tween != null and text_shake_tween.is_valid():
			text_shake_tween.stop()
		text_shake_tween = create_tween()
		text_shake_tween.tween_method(shake_bar, 0, 0, .1)
		text_shake_tween.tween_property(self, "position", start_position, 0)

func shake_bar(_value : float):
	position = start_position + (Vector2.ONE.rotated(randf_range(0, 6.29)) * 5)
