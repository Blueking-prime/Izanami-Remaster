extends OverlayMenu

class_name Settings

@export var exit_button: Button

signal exit

func _ready() -> void:
	load_menu()

func load_menu():
	super.load_menu()
	if Global.exit_button and is_instance_valid(exit_button): exit_button.queue_free()

func _on_exit_button_pressed() -> void:
	super._on_exit_button_pressed()
	exit.emit()
