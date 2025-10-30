extends Control

class_name OverlayMenu

@export var tab_container: TabContainer
@export var menu_switcher: MenuSwitcher

@export var desc_box_container: BoxContainer
@export var selector_panel: Panel
@export var selector_group: Node

var current_tab: Control:
	get(): return tab_container.get_tab_control(tab_container.current_tab)

func _ready() -> void:
	menu_switcher.set_process_input(visible)

func load_menu():
	menu_switcher.set_process_input(visible)

func reset_focus():
	pass

func _on_exit_button_pressed() -> void:
	if is_instance_valid(selector_group) and selector_group.get_child_count():
		for i in selector_group.get_children():
			if i.visible:
				for j in selector_group.get_children(): j.hide()
				reset_focus()
				return
	hide()

func _on_visibility_changed() -> void:
	Audio.quiet(visible)
	Audio.play_show_menu_sfx(visible)
	menu_switcher.set_process_input(visible)
	if visible:
		if is_instance_valid(Global.players): Global.players.freeze()
		if not Global.exit_signal.is_connected(self._on_exit_button_pressed): Global.exit_signal.connect(self._on_exit_button_pressed)
		if is_instance_valid(Global.exit_button): Global.exit_button.show()
		Global.description_box_parent = desc_box_container
	else :
		if self.name == 'Settings' and is_node_ready(): SaveAndLoad.save_settings()
		if Global.exit_signal.is_connected(self._on_exit_button_pressed): Global.exit_signal.disconnect(self._on_exit_button_pressed)
		if is_instance_valid(Global.exit_button): Global.exit_button.hide()
		if is_instance_valid(Global.players): Global.players.unfreeze()
		if is_instance_valid(Global.description_box): Global.description_box.hide()
