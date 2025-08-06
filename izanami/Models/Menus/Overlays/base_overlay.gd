extends Control

class_name UIOverlay

## PLAYER DATA OVERLAY
@export var player_status: PlayerDataDisplay

## RESOURCE CONTAINER
@export var coin_counter: Label
@export var mag_counter: Label

@export var button_container: Container

## OVERLAYS
@export var settings_menu: Settings
@export var inventory_menu: InventoryMenu
@export var status_menu: StatusOverlay

@export var map_cam: Map
@export var free_cam: FreeCam

var curr_menu: Control
var menu_list: Array
var save_enabled: bool = true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory_key"):
		_on_inventory_button_pressed()
	elif event.is_action_pressed("status_key"):
		_on_status_button_pressed()
	elif event.is_action_pressed("settings_key"):
		_on_settings_button_pressed()
	elif event.is_action_pressed("save_key"):
		_on_save_button_pressed()
	elif event.is_action_pressed("load_key"):
		_on_load_button_pressed()
	elif event.is_action_pressed("quit_key"):
		_on_quit_button_pressed()
	elif event.is_action_pressed('menu_key'):
		_on_menu_button_pressed()
	elif event.is_action_pressed("log_key"):
		_on_log_button_pressed()
	elif event.is_action_pressed("map_key"):
		_on_map_button_pressed()
	elif event.is_action_pressed('freecam_key'):
		_on_freecam_button_pressed()

	elif event.is_action_pressed("switch_leader_key"):
		status_menu._on_switch_button_pressed()

func _get_key_event_keycode(action_name: String):
	return char(InputMap.action_get_events(action_name)[Checks.input_type].keycode)

func _assign_button_labels():
	for i in button_container.get_children():
		var button_name: String = i.name.trim_suffix('Button')
		var event_key: String = _get_key_event_keycode(button_name.to_lower() + '_key')
		i.text = button_name + ' (' + event_key + ')'

func _clear_visible_menus():
	var retain_freeze: bool = Global.players.frozen
	for i in menu_list:
		if i and i.visible:
			i._on_exit_button_pressed()

	if retain_freeze: Global.players.freeze()

func update_coin_counter():
	coin_counter.text = str(Global.players.gold)

func load_ui_elements():
	_assign_button_labels()
	menu_list = [inventory_menu, settings_menu, status_menu]
	player_status.display_player_data()
	update_coin_counter()
	mag_counter.text = str(Global.players.mag)
	settings_menu.load_menu()

func _on_inventory_button_pressed() -> void:
	Global.players.freeze()

	inventory_menu.load_inventory()
	inventory_menu.tab_container.grab_focus()
	if inventory_menu.visible:
		inventory_menu._on_exit_button_pressed()
	else:
		_clear_visible_menus()
		inventory_menu.show()
		Global.exit_button.show()

func _on_settings_button_pressed() -> void:
	Global.players.freeze()

	settings_menu.load_menu()
	if settings_menu.visible:
		settings_menu._on_exit_button_pressed()
	else:
		_clear_visible_menus()
		settings_menu.show()
		Global.exit_button.show()


func _on_status_button_pressed() -> void:
	Global.players.freeze()

	status_menu.load_menu()
	if status_menu.visible:
		status_menu._on_exit_button_pressed()
	else:
		_clear_visible_menus()
		status_menu.show()
		Global.exit_button.show()

func _on_save_button_pressed() -> void:
	if not save_enabled: return
	#if Global.players.chased:
		#Global.show_text_box('', 'You cannot save now, you\'re being chased')
		#return
	SaveAndLoad.save_window.save_state = true
	SaveAndLoad.save_window.load_window()

func _on_load_button_pressed() -> void:
	SaveAndLoad.save_window.save_state = false
	SaveAndLoad.save_window.load_window()

func _on_quit_button_pressed() -> void:
	## Request confirmation
	Global.call_deferred("load_main_menu")

func _on_map_button_pressed() -> void:
	if map_cam:
		Global.players.freeze()
		map_cam.setup_map()

		if map_cam.is_current():
			map_cam.hide_map()
		else:
			map_cam.show_map()

func _on_freecam_button_pressed() -> void:
	if free_cam:
		Global.players.freeze()

		free_cam.setup_map()
		if free_cam.is_current():
			free_cam.hide_cam()
		else:
			free_cam.show_cam()

func _on_menu_button_pressed() -> void:
	if button_container.visible:
		button_container.hide()
	else:
		button_container.show()

func _on_log_button_pressed() -> void:
	if Global.text_log:
		if Global.text_log.visible:
			Global.text_log.hide()
			Global.players.unfreeze()
		else:
			Global.players.freeze()
			_clear_visible_menus()
			Global.text_log.show()


func _on_visibility_changed() -> void:
	if visible:
		set_process_input(visible)
