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

@export var inventory_key: InputEventKey
@export var settings_key: InputEventKey
@export var status_key: InputEventKey
@export var save_key: InputEventKey
@export var load_key: InputEventKey

@export var switch_key: InputEventKey


var players: Party
var curr_menu: Control
var menu_list: Array

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed:
			match event.keycode:
				inventory_key.keycode: _on_inventory_button_pressed()
				settings_key.keycode: _on_settings_button_pressed()
				status_key.keycode: _on_status_button_pressed()
				save_key.keycode: _on_save_button_pressed()
				load_key.keycode: _on_load_button_pressed()
				switch_key.keycode: status_menu._on_switch_button_pressed()
		if event.is_action_pressed("ui_cancel"):
			_clear_visible_menus()

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
	SaveAndLoad.save_window.save_state = true
	SaveAndLoad.save_window.load_window()


func _on_load_button_pressed() -> void:
	SaveAndLoad.save_window.save_state = false
	SaveAndLoad.save_window.load_window()
