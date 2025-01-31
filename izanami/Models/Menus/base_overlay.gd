extends Control

class_name UIOverlay

## STATUS OVERLAY
@export var player_status: Control

## RESOURCE CONTAINER
@export var coin_counter: Label
@export var mag_counter: Label

## OVERLAYS
@export var inventory_menu: InventoryMenu

var players

func load_ui_elements():
	players = Global.player_party
	player_status.display_player_data()
	coin_counter.text = str(players.gold)
	mag_counter.text = str(players.mag)

func _on_inventory_button_pressed() -> void:
	inventory_menu.load_inventory()
	inventory_menu.show()


func _on_settings_button_pressed() -> void:
	pass # Replace with function body.
