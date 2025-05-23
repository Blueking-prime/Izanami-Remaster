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

	option.option_name.text = option_name

	for i in quantities:
		option.add_label(str(i))

	button_container.add_child(option)
	option.selected.connect(_on_option_selected)
	option.activated.connect(_on_option_activated)

	return option

func add_icon_item(icon: Texture2D, option_name: String, quantities: Array = []) -> Option:
	var option = add_item(option_name, quantities)

	option.icon = icon

	return option

func get_item_text(index: int) -> String:
	return button_container.get_child(index).option_name.text

func _on_option_selected(index: int):
	item_selected.emit(index)

func _on_option_activated(index: int):
	item_activated.emit(index)


func _on_focus_entered() -> void:
	if button_container.get_children():
		button_container.get_child(0).call_deferred('grab_focus')
