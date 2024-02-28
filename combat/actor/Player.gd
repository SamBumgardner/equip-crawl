class_name Player extends Combatant

signal player_move(distance : Position.Ranges, lateral_position : Position.Direction)
signal action_used(action_index : InputIndices, remaining_count : int)

@export var distance : Position.Ranges = Position.Ranges.MEDIUM
@export var lateral_position : Position.Direction = Position.Direction.SOUTH

var available_actions : Array[Action] = [
	Action_PlayerMoveForward.new(),
	Action_PlayerMoveRight.new(),
	Action_PlayerMoveBackward.new(),
	Action_PlayerMoveLeft.new(),
	null,
	null,
	Action_PlayerAttack.new(),
	Action_PlayerPowerAttack.new(),
]

func _init():
	possible_states = [
		PlayerIdle.new(self),
		State_Charge.new(self),
		State_Act.new(self),
		State_Recover.new(self),
	]
	hurt_visual_effect = VisualEffect.new("player_hurt")
	block_visual_effect = VisualEffect.new("player_block")
	defeated_visual_effect = VisualEffect.new("player_defeated")

func _to_string():
	return "Player"

func _is_received_effect_in_range(effect_to_check : CombatActionEffect) -> bool:
	var in_range : bool = true;

	var effect_range = effect_to_check.effective_range;
	
	if (effect_to_check.target == CombatActionEffect.Target.OTHER && effect_range != null):
		# effect came from enemy
		var enemy = target_other as Enemy
		var within_distance = distance <= effect_range.max_range and distance >= effect_range.min_range
		
		var position_relative_to_enemy = (lateral_position - enemy.facing + 4) % 4 
		var current_range_direction = 0
		match position_relative_to_enemy:
			0: current_range_direction = EffectiveRange.RangeDirections.FRONT
			1: current_range_direction = EffectiveRange.RangeDirections.RIGHT
			2: current_range_direction = EffectiveRange.RangeDirections.BACK
			3: current_range_direction = EffectiveRange.RangeDirections.LEFT
		var within_lateral : bool = current_range_direction & effect_range.directions 

		in_range = within_distance and within_lateral
	
	if (!in_range):
		print("Effect ", effect_to_check, " missed!")

	return in_range

func _apply_move_effect(received_effect : MoveEffect):
	var unbound_distance = distance + received_effect.range_direction * received_effect.amount
	distance = max(min(unbound_distance, Position.Ranges.LONG), Position.Ranges.SHORT)
	var unlooped_lateral = lateral_position + received_effect.lateral_direction * received_effect.amount
	lateral_position = ((unlooped_lateral + 4) % 4) as Position.Direction
	
	print(self, " moved! New position is distance ", distance, " lateral ", lateral_position)
	player_move.emit(distance, lateral_position)

func get_available_action(input : InputIndices) -> Action:
	var result = null
	if available_actions.size() > input:
		var selected_action = available_actions[input]
		if selected_action != null and selected_action.consume_use():
			action_used.emit(input, selected_action.remaining_uses)
			result = available_actions[input]
	return result

enum InputIndices {
	UP = 0,
	RIGHT = 1,
	DOWN = 2,
	LEFT = 3,
	BUTTON_0_0 = 4,
	BUTTON_1_0 = 5,
	BUTTON_0_1 = 6,
	BUTTON_1_1 = 7
}

const PLAYER_INPUTS = {
	"direction_up": InputIndices.UP,
	"direction_right": InputIndices.RIGHT,
	"direction_down": InputIndices.DOWN,
	"direction_left": InputIndices.LEFT,
	"action_0_0": InputIndices.BUTTON_0_0,
	"action_1_0": InputIndices.BUTTON_1_0,
	"action_0_1": InputIndices.BUTTON_0_1,
	"action_1_1": InputIndices.BUTTON_1_1,
}
