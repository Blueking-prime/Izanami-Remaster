extends ScrollContainer

class_name Options

@export var button_container: VBoxContainer

@export var option_scene: PackedScene

signal item_activated(index: int)
signal item_selected(index: int)

func clear():
	for i in button_container.get_children():
		button_container.remove_child(i)
		i.queue_free()

func add_item(option_name: String, quantity_1: String = '', quantity_2: String = '', quantity_3: String = '', quantity_4: String = '', quantity_5: String = '') -> Option:
	var option: Option = option_scene.instantiate()

	option.option_name.text = option_name

	if quantity_1:
		option.quantity_1.text = quantity_1
		option.quantity_1.show()
	if quantity_2:
		option.quantity_2.text = quantity_2
		option.quantity_2.show()
	if quantity_3:
		option.quantity_3.text = quantity_3
		option.quantity_3.show()
	if quantity_4:
		option.quantity_4.text = quantity_4
		option.quantity_4.show()
	if quantity_5:
		option.quantity_5.text = quantity_5
		option.quantity_5.show()

	button_container.add_child(option)
	option.selected.connect(_on_option_selected)
	option.activated.connect(_on_option_activated)

	return option

func add_icon_item(icon: Texture2D, option_name: String, quantity_1: String = '', quantity_2: String = '', quantity_3: String = '', quantity_4: String = '', quantity_5: String = '') -> Option:
	var option = add_item(option_name, quantity_1, quantity_2, quantity_3, quantity_4, quantity_5)

	option.icon = icon

	return option

func get_item_text(index: int) -> String:
	return button_container.get_child(index).option_name.text

func _on_option_selected(index: int):
	item_selected.emit(index)

func _on_option_activated(index: int):
	item_activated.emit(index)
