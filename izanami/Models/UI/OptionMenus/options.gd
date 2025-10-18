extends ScrollContainer

class_name Options

@export var button_container: VBoxContainer

@export var option_scene: PackedScene

var first_option: Option

signal item_activated(index: int)
signal item_selected(index: int)

func clear():
	for i in button_container.get_children():
		button_container.remove_child(i)
		i.queue_free()

func add_item(option_name: String, quantities: Array = []) -> Option:
	var option: Option = option_scene.instantiate()

	option.option_name = option_name

	for i in quantities:
		option.add_label(str(i))

	button_container.add_child(option)
	option.root_menu = self

	option.selected.connect(_on_option_selected)
	option.activated.connect(_on_option_activated)

	return option

func add_icon_item(icon: Texture2D, option_name: String, quantities: Array = []) -> Option:
	var option = add_item(option_name, quantities)

	option.icon = icon

	return option

func get_item_option(index: int) -> Option:
	if index < button_container.get_child_count():
		return button_container.get_child(index)
	else :
		return button_container.get_child(-1)

func get_item_text(index: int) -> String:
	return get_item_option(index).option_name

func disable():
	for i in button_container.get_children():
		i.disabled = true

func enable():
	for i in button_container.get_children():
		i.disabled = false


func _on_option_selected(index: int):
	item_selected.emit(index)

func _on_option_activated(index: int):
	item_activated.emit(index)

func _on_focus_entered() -> void:
	if button_container.get_children():
		button_container.get_child(0).call_deferred('grab_focus')


func _input(event: InputEvent) -> void:
	if not visible: return

	var current_focus = get_viewport().gui_get_focus_owner()
	if not is_instance_valid(current_focus): return
	if current_focus is not Option: return
	if button_container != current_focus.get_parent(): return

	var curr_index = current_focus.get_index()

	if event.is_action_pressed("ui_down"):
		if curr_index + 1 < button_container.get_child_count():
			button_container.get_child(curr_index + 1).call_deferred('grab_focus')
		else :
			button_container.get_child(0).call_deferred('grab_focus')
	if event.is_action_pressed("ui_up"):
		if curr_index - 1 >= 0:
			button_container.get_child(curr_index - 1).call_deferred('grab_focus')
		else :
			button_container.get_child(-1).call_deferred('grab_focus')
