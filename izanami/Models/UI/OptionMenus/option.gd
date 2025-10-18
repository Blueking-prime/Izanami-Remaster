extends Button

class_name Option

@export var container: HBoxContainer

var option_name: String:
	set(arg):
		text = ' ' + arg
		option_name = arg

var root_menu: Options

signal activated(index: int)
signal selected(index: int)

func add_label(quantity_text: String):
	var quantity: Label = Label.new()

	quantity.text = quantity_text
	quantity.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	quantity.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	quantity.custom_minimum_size.x = 10
	quantity.size_flags_horizontal = Control.SIZE_SHRINK_END && Control.SIZE_EXPAND
	quantity.size_flags_vertical = Control.SIZE_FILL

	container.add_child(quantity)


func _on_focus_entered() -> void:
	selected.emit(get_index())
	Audio.play_select_option_sfx()


func _on_button_down() -> void:
	activated.emit(get_index())
	Audio.play_activate_option_sfx()
