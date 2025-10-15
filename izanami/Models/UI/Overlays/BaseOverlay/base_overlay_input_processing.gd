extends Node

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory_key"):
		get_parent()._on_inventory_button_pressed()
	elif event.is_action_pressed("status_key"):
		get_parent()._on_status_button_pressed()
	elif event.is_action_pressed("settings_key"):
		get_parent()._on_settings_button_pressed()
	elif event.is_action_pressed("quests_key"):
		get_parent()._on_quests_button_pressed()
	elif event.is_action_pressed("save_key"):
		get_parent()._on_save_button_pressed()
	elif event.is_action_pressed("load_key"):
		get_parent()._on_load_button_pressed()
	elif event.is_action_pressed("quit_key"):
		get_parent()._on_quit_button_pressed()
	elif event.is_action_pressed('menu_key'):
		get_parent()._on_menu_button_pressed()
	elif event.is_action_pressed("log_key"):
		get_parent()._on_log_button_pressed()
	elif event.is_action_pressed("map_key"):
		get_parent()._on_map_button_pressed()
	elif event.is_action_pressed('freecam_key'):
		get_parent()._on_freecam_button_pressed()
	elif event.is_action_pressed('ui_key'):
		get_parent()._on_ui_button_pressed()

	elif event.is_action_pressed("switch_leader_key"):
		get_parent().status_menu._on_switch_button_pressed()
