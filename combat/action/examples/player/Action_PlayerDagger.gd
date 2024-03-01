class_name Action_PlayerDagger extends Action

const BASE_DAMAGE = 1
const CRIT_MULTIPLIER = 3

static var on_act_actions:Array[CombatActionEffect]

func _init():
	name = "Backstab Dagger"
	charge_time = 0
	recovery_time = .5
	icon = preload("res://art/input_display/action_icons/dagger.png")
	max_uses = 20
	remaining_uses = 20
	
	if (on_act_actions.is_empty()):
		var range1 = EffectiveRange.new(Position.Ranges.SHORT, Position.Ranges.SHORT, 
			EffectiveRange.RangeDirections.ALL)
		var damage_effect = DamageEffect.new(CombatActionEffect.Target.OTHER, range1, BASE_DAMAGE)
		var visual_effect = VisualEffect.new("player_bounce_forward")

		on_act_actions = [damage_effect, visual_effect] 

func on_act() -> Array[CombatActionEffect]:
	if enemy.get_turn_direction_toward_player() == MoveEffect.LateralDirection.OPPOSITE:
		on_act_actions[0].amount = BASE_DAMAGE * CRIT_MULTIPLIER
	else:
		on_act_actions[0].amount = BASE_DAMAGE
	return on_act_actions
