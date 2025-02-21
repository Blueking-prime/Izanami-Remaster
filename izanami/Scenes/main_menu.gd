extends Node

@export var load_button: Button

func _ready() -> void:
	SaveAndLoad.get_save_files()
	if SaveAndLoad.save_files.size():
		load_button.show()

func _on_load_pressed() -> void:
	SaveAndLoad.save_window.save_state = false
	SaveAndLoad.save_window.load_window()

func _on_new_pressed() -> void:
	## Go to new game scene
	SaveAndLoad.load_town()

func _on_settings_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
