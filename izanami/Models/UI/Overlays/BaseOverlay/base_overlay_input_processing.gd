extends Node

class_name UIOverlayInputProcessor

@export var button_container: Container

var save_menu: SaveMenu:
	get(): return get_parent().save_menu
var settings_menu: Settings:
	get(): return get_parent().settings_menu
var inventory_menu: InventoryMenu:
	get(): return get_parent().inventory_menu
var quests_menu: QuestMenu:
	get(): return get_parent().quests_menu
var status_menu: StatusOverlay:
	get(): return get_parent().status_menu
var map_cam: Map:
	get(): return get_parent().map_cam
var free_cam: FreeCam:
	get(): return get_parent().free_cam


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory_key"):
		_on_inventory_button_pressed()
	elif event.is_action_pressed("status_key"):
		_on_status_button_pressed()
	elif event.is_action_pressed("settings_key"):
		_on_settings_button_pressed()
	elif event.is_action_pressed("quests_key"):
		_on_quests_button_pressed()
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
	elif event.is_action_pressed('ui_key'):
		_on_ui_button_pressed()

	elif event.is_action_pressed("switch_leader_key"):
		status_menu._on_switch_button_pressed()


func _clear_visible_menus():
	var retain_freeze: bool = Global.players.frozen
	for i in get_parent().menu_list:
		if i and i.visible:
			i._on_exit_button_pressed()

	if retain_freeze: Global.players.freeze()


#region Signal Handler
func _on_menu_opened(menu: OverlayMenu) -> void:
	menu.load_menu()

	if menu.visible:
		menu._on_exit_button_pressed()
	else :
		_clear_visible_menus()
		menu.show()

func _on_inventory_button_pressed() -> void:
	_on_menu_opened(inventory_menu)
	if inventory_menu.visible: inventory_menu.tab_container.grab_focus()

func _on_settings_button_pressed() -> void:
	_on_menu_opened(settings_menu)

func _on_quests_button_pressed() -> void:
	_on_menu_opened(quests_menu)

func _on_status_button_pressed() -> void:
	status_menu.load_menu()
	if status_menu.visible:
		status_menu._on_exit_button_pressed()
	else:
		_clear_visible_menus()
		status_menu.show()

func _on_save_button_pressed() -> void:
	if not get_parent().save_enabled: return
	SaveAndLoad.save_state = true

	save_menu.load_menu()
	if save_menu.visible:
		save_menu._on_exit_button_pressed()
	else:
		_clear_visible_menus()
		save_menu.show()

func _on_load_button_pressed() -> void:
	SaveAndLoad.save_state = false

	save_menu.load_menu()
	if save_menu.visible:
		save_menu._on_exit_button_pressed()
	else:
		_clear_visible_menus()
		save_menu.show()

func _on_quit_button_pressed() -> void:
	var confirm = await Global.show_confirmation_box('Exit to Main Menu? ')
	if confirm:
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
		print(free_cam)
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
		button_container.get_child(0).grab_focus()

func _on_log_button_pressed() -> void:
	if Global.text_log:
		if Global.text_log.visible:
			Global.text_log.hide()
			Global.players.unfreeze()
		else:
			Global.players.freeze()
			_clear_visible_menus()
			Global.text_log.show()

func _on_ui_button_pressed() -> void:
	if get_parent().visible:
		get_parent().hide()
	else:
		get_parent().show()
#endregion
