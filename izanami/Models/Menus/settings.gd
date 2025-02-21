extends Control

class_name Settings

@export var exit_button: Button

signal exit

func _on_exit_button_pressed() -> void:
	exit.emit()
	hide()
