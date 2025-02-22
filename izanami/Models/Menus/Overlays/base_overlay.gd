extends Control

class_name UIOverlay

## STATUS OVERLAY
@export var player_status: Control

## RESOURCE CONTAINER
@export var coin_counter: Label
@export var mag_counter: Label

## OVERLAYS
@export var inventory_menu: InventoryMenu
@export var settings_menu: Control
@export var status_menu: StatusOverlay


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

	elif event.is_action_pressed("switch_leader_key"):
		status_menu._on_switch_button_pressed()

func _clear_visible_menus():
	for i in menu_list:
		if i and i.visible:
			i._on_exit_button_pressed()

func load_ui_elements():
	players = Global.player_party
	menu_list = [inventory_menu, settings_menu, status_menu]
	player_status.display_player_data()
	coin_counter.text = str(players.gold)
	mag_counter.text = str(players.mag)


func _on_inventory_button_pressed() -> void:
	Global.player_party.freeze()

	inventory_menu.load_inventory()
	inventory_menu.tab_container.grab_focus()
	if inventory_menu.visible:
		inventory_menu._on_exit_button_pressed()
	else:
		_clear_visible_menus()
		inventory_menu.show()


func _on_settings_button_pressed() -> void:
	pass # Replace with function body.


func _on_status_button_pressed() -> void:
	Global.player_party.freeze()

	status_menu.load_menu()
	if status_menu.visible:
		status_menu._on_exit_button_pressed()
	else:
		_clear_visible_menus()
		status_menu.show()


func _on_save_button_pressed() -> void:
	if not Global.player_party.chased:
		SaveAndLoad.save_window.save_state = true
		SaveAndLoad.save_window.load_window()


func _on_load_button_pressed() -> void:
	SaveAndLoad.save_window.save_state = false
	SaveAndLoad.save_window.load_window()


func _on_quit_button_pressed() -> void:
	## Request confirmation
	Global.call_deferred("load_main_menu")
