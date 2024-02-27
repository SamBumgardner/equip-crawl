class_name ActionBadge extends VBoxContainer

func set_action(action : Action):
	$ActionName.text = action.name
	$Background/Icon.texture = action.icon
