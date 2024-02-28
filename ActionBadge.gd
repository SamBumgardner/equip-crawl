class_name ActionBadge extends VBoxContainer

func set_action(action : Action):
	$ActionName.text = action.name
	$MarginContainer/Background/Icon.texture = action.icon
	$MarginContainer/Background/UsesRemaining.text = str(action.remaining_uses)
