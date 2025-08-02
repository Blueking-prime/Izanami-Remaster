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
	Global.exit_signal.disconnect(_on_exit_button_pressed)
	items_menu.target_selector.hide()
	gear_menu.target_selector.hide()
	skills_menu.target_selector.hide()
	Global.exit_button.hide()
	Global.players.unfreeze()
	hide()

func _on_visibility_changed() -> void:
	menu_switcher.set_process_input(visible)
	if visible:
		if not Global.exit_signal.is_connected(_on_exit_button_pressed): Global.exit_signal.connect(_on_exit_button_pressed)
		tab_container.get_child(Checks.inventory_tab).show()
