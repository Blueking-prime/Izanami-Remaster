extends Control

class_name InventoryMenu

@export var items_menu: Control
@export var gear_menu: Control
@export var misc_menu: Control

func load_inventory():
	items_menu.load_stock()
	gear_menu.load_stock()


func _on_exit_button_pressed() -> void:
	Global.player_party.unfreeze()
	hide()
