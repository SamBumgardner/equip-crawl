class_name Action_SpearSweep extends Action

static var on_act_actions:Array[CombatActionEffect]

static var last_turn_direction = -1

func _init(owning_enemy : Enemy):
	enemy = owning_enemy
	
	name = "Spear Sweep"
	charge_time = 1
	recovery_time = 1
	
	if (on_act_actions.is_empty()):
		var range1 = EffectiveRange.new(Position.Ranges.SHORT, Position.Ranges.SHORT, 
			EffectiveRange.RangeDirections.RIGHT + EffectiveRange.RangeDirections.LEFT + EffectiveRange.RangeDirections.FRONT)
		var damage_effect = DamageEffect.new(CombatActionEffect.Target.OTHER, range1, 1)
		var move_effect = MoveEffect.new(CombatActionEffect.Target.OTHER, range1, 1, 0, 1)
		var stun_effect = StunEffect.new(CombatActionEffect.Target.OTHER, range1, 1)
		var knockback_visual_effect = VisualEffect.new("player_knockback", 
			CombatActionEffect.Target.OTHER, range1)
		var attack_visual_effect = VisualEffect.new("enemy_lunge")
		# visual effect with range

		on_act_actions = [damage_effect, move_effect, stun_effect, 
			attack_visual_effect, knockback_visual_effect] 

func on_act() -> Array[CombatActionEffect]:
	return on_act_actions
