extends Node

@export var load_button: Button
@export var settings_menu: Settings
@export var canvas_layer: CanvasLayer

func _ready() -> void:
	SaveAndLoad.get_save_files()
	if SaveAndLoad.save_files.size():
		load_button.show()

func _on_load_pressed() -> void:
	SaveAndLoad.save_window.save_state = false
	SaveAndLoad.save_window.load_window()

func _on_new_pressed() -> void:
	## Go to new game scene
	SaveAndLoad.call_deferred("load_town")

func _on_settings_pressed() -> void:
	canvas_layer.hide()
	settings_menu.show()

func _on_settings_exit() -> void:
	canvas_layer.show()

func _on_quit_pressed() -> void:
	get_tree().call_deferred("quit")
