extends Control

class_name UIOverlay

## STATUS OVERLAY
@export var player_status: Control

## RESOURCE CONTAINER
@export var coin_counter: Label
@export var mag_counter: Label

## OVERLAYS
@export var inventory_menu: InventoryMenu

@export var inventory_key: InputEventKey
@export var settings_key: InputEventKey
@export var status_key: InputEventKey

var players: Party

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed:
			match event.keycode:
				inventory_key.keycode: _on_inventory_button_pressed()
				settings_key.keycode: pass
				status_key.keycode: pass
		if event.is_action_pressed("ui_cancel") and inventory_menu.visible:
			_on_inventory_button_pressed()

func load_ui_elements():
	players = Global.player_party
	player_status.display_player_data()
	coin_counter.text = str(players.gold)
	mag_counter.text = str(players.mag)

func _on_inventory_button_pressed() -> void:
	Global.player_party.freeze()

	inventory_menu.load_inventory()
	if inventory_menu.visible:
		inventory_menu._on_exit_button_pressed()
	else:
		inventory_menu.show()


func _on_settings_button_pressed() -> void:
	pass # Replace with function body.
