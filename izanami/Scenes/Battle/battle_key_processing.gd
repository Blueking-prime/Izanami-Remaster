class_name BattleKeyProcessing

extends Node

@export var log_panel: Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("log_key"):
		if log_panel.visible:
			log_panel.hide()
		else:
			log_panel.show()
	if get_parent().targetting:
		#if is_instance_of(process_turns.actors[index], Player):
		if event.is_action_pressed("ui_left"):
			get_parent()._left_press()
		if event.is_action_pressed("ui_right"):
			get_parent()._right_press()
		if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down"):
			get_parent()._up_or_down_press()
		if event.is_action_pressed("number"):
			get_parent()._set_target_by_index(event)
		if event.is_action_pressed("ui_accept"):
			get_parent().process_actions.action()

	# Cancelout of action only if currently acting character is a player
	if event.is_action_pressed('ui_cancel') and \
	get_parent().process_turns.current_player == get_parent().process_turns.turn_order[get_parent().process_turns.idx]:
		get_parent()._cancel_targetting()
