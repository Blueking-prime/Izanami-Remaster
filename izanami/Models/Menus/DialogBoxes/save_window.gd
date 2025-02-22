extends Window

class_name SaveWindow

@export var save_menu: SaveMenu
@export var confirm_button: Button

@export var save_state: bool

func load_window():
	if save_state:
		title = "Choose save file"
		confirm_button.text = "Create New Save"
	else:
		title = "Load from file"
		confirm_button.text = "Load Last Save"
	save_menu.save_state = save_state
	save_menu.load_stock()
	show()

func _on_close_requested() -> void:
	hide()
