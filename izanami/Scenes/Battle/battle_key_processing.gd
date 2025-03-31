class_name BattleKeyProcessing

extends Node

@export var log_panel: Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("log_key"):
		if log_panel.visible:
			log_panel.hide()
		else:
			log_panel.show()
