extends Control

class_name UIOverlay

## STATUS OVERLAY
@export var player_status: Control

@export var input_type: int

## RESOURCE CONTAINER
@export var coin_counter: Label
@export var mag_counter: Label

## OVERLAYS
@export var inventory_menu: InventoryMenu
@export var settings_menu: Settings
@export var status_menu: StatusOverlay

@export var button_container: Container

@export var map: Map
@export var free_cam: FreeCam

var players: Party
var curr_menu: Control
var menu_list: Array


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
	elif event.is_action_pressed("map_key"):
		if map: _on_map_button_pressed()
	elif event.is_action_pressed('freecam_key'):
		if free_cam: _on_freecam_button_pressed()


	elif event.is_action_pressed("switch_leader_key"):
		status_menu._on_switch_button_pressed()

func _get_key_event_keycode(action_name: String):
	return char(InputMap.action_get_events(action_name)[Global.input_type].keycode)

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

func load_ui_elements():
	_assign_button_labels()
	players = Global.players
	menu_list = [inventory_menu, settings_menu, status_menu]
	player_status.display_player_data()
	coin_counter.text = str(players.gold)
	mag_counter.text = str(players.mag)
	settings_menu.load_menu()
	if map: map.setup_map()
	if free_cam: free_cam.players = players


func _on_inventory_button_pressed() -> void:
	Global.players.freeze()

	inventory_menu.load_inventory()
	inventory_menu.tab_container.grab_focus()
	if inventory_menu.visible:
		inventory_menu._on_exit_button_pressed()
	else:
		_clear_visible_menus()
		inventory_menu.show()


func _on_settings_button_pressed() -> void:
	Global.players.freeze()

	settings_menu.load_menu()
	if settings_menu.visible:
		settings_menu._on_exit_button_pressed()
	else:
		_clear_visible_menus()
		settings_menu.show()



func _on_status_button_pressed() -> void:
	Global.players.freeze()

	status_menu.load_menu()
	if status_menu.visible:
		status_menu._on_exit_button_pressed()
	else:
		_clear_visible_menus()
		status_menu.show()

func _on_save_button_pressed() -> void:
	if not Global.players.chased:
		SaveAndLoad.save_window.save_state = true
		SaveAndLoad.save_window.load_window()


func _on_load_button_pressed() -> void:
	SaveAndLoad.save_window.save_state = false
	SaveAndLoad.save_window.load_window()


func _on_quit_button_pressed() -> void:
	## Request confirmation
	Global.call_deferred("load_main_menu")


func _on_visibility_changed() -> void:
	if visible:
		set_process_input(visible)


func _on_map_button_pressed() -> void:
	Global.players.freeze()

	map.setup_map()
	if map.visible:
		map.hide_map()
	else:
		map.show_map()

func _on_freecam_button_pressed() -> void:
	Global.players.freeze()

	free_cam.setup_map()
	if free_cam.is_current():
		free_cam.hide_cam()
	else:
		free_cam.show_cam()
