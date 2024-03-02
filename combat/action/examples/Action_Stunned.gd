class_name Action_Stunned extends Action


func _init(recovery_time_in : float, custom_name : String = "Stunned"):
	name = custom_name
	charge_time = 0
	recovery_time = recovery_time_in
	# todo: maybe add a visual effect when "on act"?
