class_name Action_PlayerHammer extends Action

const BASE_DAMAGE : float = 2
const BASE_DURATION : float = 1 

static var on_act_actions:Array[CombatActionEffect]
static var on_charge_start_actions:Array[CombatActionEffect]

func _init():
	name = "Lucky Hammer"
	charge_time = 1.5
	recovery_time = .5
	icon = preload("res://art/input_display/action_icons/lucky_hammer.png")
	max_uses = 7
	remaining_uses = 7
	
	if (on_act_actions.is_empty()):
		var range1 = EffectiveRange.new(Position.Ranges.SHORT, Position.Ranges.SHORT, 
			EffectiveRange.RangeDirections.ALL)
		var damage_effect = DamageEffect.new(CombatActionEffect.Target.OTHER, range1, )
		var stun_effect = StunEffect.new(CombatActionEffect.Target.OTHER, range1, 1)
		var visual_effect = VisualEffect.new("player_bounce_forward")

		on_act_actions = [damage_effect, stun_effect, visual_effect] 
	
	if (on_charge_start_actions.is_empty()):
		var visual_effect = VisualEffect.new("player_charge")
		on_charge_start_actions = [visual_effect]


func on_act() -> Array[CombatActionEffect]:
	var roll = randi_range(0 , 9)
	if roll > remaining_uses:
		print("LUCKY!!!")
		on_act_actions[0].amount = BASE_DAMAGE * 2
		on_act_actions[1].duration = BASE_DURATION * 2
	else:
		on_act_actions[0].amount = BASE_DAMAGE
		on_act_actions[1].duration = BASE_DURATION
	
	return on_act_actions

func on_charge_start() -> Array[CombatActionEffect]:
	return on_charge_start_actions
