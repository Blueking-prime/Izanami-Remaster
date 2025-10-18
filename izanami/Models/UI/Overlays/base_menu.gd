extends Control

class_name OverlayMenu

@export var tab_container: TabContainer
@export var menu_switcher: MenuSwitcher

@export var desc_box_container: BoxContainer

func _ready() -> void:
	menu_switcher.set_process_input(visible)

func load_menu():
	menu_switcher.set_process_input(visible)

func _on_exit_button_pressed() -> void:
	hide()

func _on_visibility_changed() -> void:
	Audio.quiet(visible)
	Audio.play_show_menu_sfx(visible)
	menu_switcher.set_process_input(visible)
	if visible:
		if is_instance_valid(Global.players): Global.players.freeze()
		if not Global.exit_signal.is_connected(_on_exit_button_pressed): Global.exit_signal.connect(_on_exit_button_pressed)
		if is_instance_valid(Global.exit_button): Global.exit_button.show()
		Global.description_box_parent = desc_box_container
	else :
		if Global.exit_signal.is_connected(_on_exit_button_pressed): Global.exit_signal.disconnect(_on_exit_button_pressed)
		if is_instance_valid(Global.exit_button): Global.exit_button.hide()
		if is_instance_valid(Global.players): Global.players.unfreeze()
