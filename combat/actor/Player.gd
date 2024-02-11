class_name Player extends Combatant

var distance : Position.Ranges = Position.Ranges.MEDIUM
var lateral_position : Position.Direction = Position.Direction.SOUTH

func _init():
	possible_states = [
		PlayerIdle.new(self),
		State_Charge.new(self),
		State_Act.new(self),
		State_Recover.new(self),
	]

func _is_received_effect_in_range(effect_to_check : CombatActionEffect) -> bool:
	var in_range : bool = true;

	var range = effect_to_check.effective_range;
	
	if (effect_to_check.target == CombatActionEffect.Target.OTHER):
		# effect came from enemy
		var enemy = target_other as Enemy
		var within_distance = distance <= range.max_range and distance >= range.min_range
		
		var normalized_direction = (lateral_position - enemy.facing + 4) % 4 
		# 3 means left
		# 1 means right 
		# 0 means front 
		# 2 means back
		var current_range_direction = 0
		match normalized_direction:
			0: current_range_direction = EffectiveRange.RangeDirections.FRONT
			1: current_range_direction = EffectiveRange.RangeDirections.RIGHT
			2: current_range_direction = EffectiveRange.RangeDirections.BACK
			3: current_range_direction = EffectiveRange.RangeDirections.LEFT
		var within_lateral : bool = current_range_direction & range.directions 

		in_range = within_distance and within_lateral

	return in_range