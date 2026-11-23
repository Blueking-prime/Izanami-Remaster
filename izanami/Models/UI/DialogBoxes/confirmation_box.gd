extends ConfirmationDialog

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_cancel'):# or event.is_action_pressed('ui_close_dialog'):
		canceled.emit()
