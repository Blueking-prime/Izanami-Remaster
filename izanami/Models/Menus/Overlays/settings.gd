extends Control

class_name Settings

@export var exit_button: Button
@export var menu_switcher: MenuSwitcher

signal exit

func _ready() -> void:
	load_menu()

func load_menu():
	menu_switcher.set_process_input(visible)
	if Global.exit_button:
		if is_instance_valid(exit_button):
			exit_button.queue_free()


func _on_exit_button_pressed() -> void:
	if Global.exit_signal.is_connected(_on_exit_button_pressed): Global.exit_signal.disconnect(_on_exit_button_pressed)
	Global.exit_button.hide()
	exit.emit()
	hide()
	if is_instance_valid(Global.players): Global.players.unfreeze()

func _on_visibility_changed() -> void:
	menu_switcher.set_process_input(visible)
	if visible:
		if not Global.exit_signal.is_connected(_on_exit_button_pressed): Global.exit_signal.connect(_on_exit_button_pressed)
