extends Node

class_name MainMenu

@export var load_button: Button
@export var new_button: Button

@export var menu_ui: Control
@export var exit_button: Button
@export var settings_menu: Settings
@export var save_menu: SaveMenu
@export var canvas_layer: CanvasLayer

func _ready() -> void:
	SaveAndLoad.get_save_files()

	Global.exit_button = exit_button
	if not Global.exit_signal.is_connected(_on_exit_button_pressed): Global.exit_signal.connect(_on_exit_button_pressed)

	new_button.grab_focus()
	if SaveAndLoad.save_files.size():
		load_button.disabled = false
		load_button.grab_focus()

func _on_load_pressed() -> void:
	SaveAndLoad.save_state = false
	save_menu.load_menu()
	save_menu.show()

func _on_new_pressed() -> void:
	## Go to new game scene
	SaveAndLoad.call_deferred("load_town")

func _on_settings_pressed() -> void:
	menu_ui.hide()
	settings_menu.show()

func _on_exit_button_pressed():
	menu_ui.show()
	load_button.grab_focus()

func _on_quit_pressed() -> void:
	var confirm = await Global.show_confirmation_box('Exit game?')
	if confirm: get_tree().call_deferred("quit")
