class_name Action_Stunned extends Action


func _init(recovery_time_in : float):
	name = "Stunned"
	charge_time = 0
	recovery_time = recovery_time_in
	# todo: maybe add a visual effect when "on act"?
