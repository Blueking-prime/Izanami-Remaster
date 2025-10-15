class_name BattleKeyProcessing

extends Node

@export var log_panel: Control

var choice: Control:
	get():
		return get_parent().choice

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("log_key"):
		if log_panel.visible:
			log_panel.hide()
		else:
			log_panel.show()

	if not get_parent().input_disabled:
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

	if get_parent().choice.visible:
		var current_focus = get_viewport().gui_get_focus_owner()
		if not is_instance_valid(current_focus): return
		#if current_focus is not Button: return
		if choice != current_focus.get_parent(): return

		var curr_index = current_focus.get_index()

		if event.is_action_pressed("ui_down"):
			if curr_index + 1 < choice.get_child_count():
				choice.get_child(curr_index + 1).call_deferred('grab_focus')
			else :
				choice.get_child(0).call_deferred('grab_focus')
		if event.is_action_pressed("ui_up"):
			if curr_index - 1 >= 0:
				choice.get_child(curr_index - 1).call_deferred('grab_focus')
			else :
				choice.get_child(-1).call_deferred('grab_focus')
