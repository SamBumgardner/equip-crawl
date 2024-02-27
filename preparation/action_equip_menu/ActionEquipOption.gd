extends PanelContainer

func _on_focus_entered():
	$Button.grab_focus()

func _test():
	print("button press occurred")
