class_name Transition extends ColorRect

static var transitionable_scenes = {
	"combat": preload("res://combat/scene/Combat.tscn"),
	"exploration": preload("res://exploration/scene/ExplorationLoop.tscn") 
}

var current_scene;

func _init():
	visible = false

func _on_start_transition_out(transition_data : TransitionData, cleanup_callback : Callable):
	print("\n", transition_data)
	var next_scene_name = "exploration" #default val in case something goes wrong.
	if transition_data.next_scene_name in transitionable_scenes.keys():
		next_scene_name = transition_data.next_scene_name
	
	var fade_in_tween = create_fade_in_tween()
	fade_in_tween.tween_callback(cleanup_callback)
	fade_in_tween.tween_callback(set_up_new_transitionable_scene.bind(next_scene_name, transition_data))
	fade_in_tween.tween_interval(.2)
	apply_fade_out_to_tween(fade_in_tween)
	
func create_fade_in_tween() -> Tween:
	visible = true
	modulate = Color.TRANSPARENT
	var fade_in_tween = create_tween()
	fade_in_tween.tween_property(self, "modulate", Color.WHITE, .75)
	return fade_in_tween

func apply_fade_out_to_tween(tween : Tween):
	tween.tween_property(self, "modulate", Color.TRANSPARENT, .75)
	tween.tween_property(self, "visible", false, 0)
	tween.tween_callback(finished_fading_in)

func set_up_new_transitionable_scene(next_scene_name : String, transition_data : TransitionData):
	var new_scene = transitionable_scenes[next_scene_name].instantiate()
	new_scene.start_transition_out.connect(_on_start_transition_out)
	new_scene.init_scene(transition_data)
	get_parent().add_child(new_scene)
	
	current_scene = new_scene

func finished_fading_in():
	current_scene.start_scene()

func no_op():
	pass
