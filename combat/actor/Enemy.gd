class_name Enemy extends Combatant

var facing : Position.Direction = Position.Direction.SOUTH

func _init():
	possible_states = [
		EnemyIdle.new(self),
		State_Charge.new(self),
		State_Act.new(self),
		State_Recover.new(self),
	]

	current_action = Action_SpearThrust.new()

func _to_string():
	return "Enemy"

func _is_received_effect_in_range(effect_to_check : CombatActionEffect) -> bool:
	var in_range : bool = true;

	var effect_range = effect_to_check.effective_range;
	
	if (effect_to_check.target == CombatActionEffect.Target.OTHER):
		# effect came from Player
		in_range = target_other.distance <= effect_range.max_range \
			and target_other.distance >= effect_range.min_range
	
	if (!in_range):
		print("Effect ", effect_to_check, " missed!")

	return in_range
