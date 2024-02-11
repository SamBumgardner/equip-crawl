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
