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
