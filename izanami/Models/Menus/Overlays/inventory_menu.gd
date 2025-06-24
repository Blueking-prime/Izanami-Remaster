extends Control

class_name InventoryMenu

@export var skills_menu: Control
@export var items_menu: Control
@export var gear_menu: Control
@export var misc_menu: Control
@export var tab_container: Control
@export var menu_switcher: MenuSwitcher

func _ready() -> void:
	menu_switcher.set_process_input(visible)

func load_inventory():
	skills_menu.load_stock()
	items_menu.load_stock()
	gear_menu.load_stock()
	menu_switcher.set_process_input(visible)


func _on_exit_button_pressed() -> void:
	Global.players.unfreeze()
	items_menu.target_selector.hide()
	gear_menu.target_selector.hide()
	skills_menu.target_selector.hide()
	hide()

func _on_visibility_changed() -> void:
	menu_switcher.set_process_input(visible)
