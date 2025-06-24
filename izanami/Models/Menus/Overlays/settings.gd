extends Control

class_name Settings

@export var exit_button: Button
@export var menu_switcher: MenuSwitcher

signal exit

func load_menu():
	menu_switcher.set_process_input(visible)

func _on_exit_button_pressed() -> void:
	exit.emit()
	hide()
	if Global.players: Global.players.unfreeze()

func _on_visibility_changed() -> void:
	menu_switcher.set_process_input(visible)
