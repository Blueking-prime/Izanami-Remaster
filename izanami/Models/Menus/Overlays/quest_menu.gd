extends Control

class_name QuestMenu

@export var active_menu: OptionMenu
@export var completed_menu: OptionMenu

@export var tab_container: TabContainer
@export var menu_switcher: MenuSwitcher

func _ready() -> void:
	menu_switcher.set_process_input(visible)

func load_menu():
	active_menu.load_stock()
	completed_menu.load_stock()

	menu_switcher.set_process_input(visible)

func _on_exit_button_pressed() -> void:
	Global.exit_signal.disconnect(_on_exit_button_pressed)
	Global.exit_button.hide()
	Global.players.unfreeze()
	hide()

func _on_visibility_changed() -> void:
	menu_switcher.set_process_input(visible)
	if visible:
		if not Global.exit_signal.is_connected(_on_exit_button_pressed): Global.exit_signal.connect(_on_exit_button_pressed)
		tab_container.get_child(Checks.quests_tab).show()
