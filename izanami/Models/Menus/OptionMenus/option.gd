extends Button

class_name Option

@export var container: HBoxContainer

@export var option_name: Label

signal activated(index: int)
signal selected(index: int)

func add_label(quantity_text: String):
	var quantity: Label = Label.new()

	quantity.text = quantity_text
	quantity.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	quantity.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	quantity.custom_minimum_size.x = 50
	quantity.size_flags_horizontal = Control.SIZE_SHRINK_END && Control.SIZE_EXPAND
	quantity.size_flags_vertical = Control.SIZE_FILL

	container.add_child(quantity)


func _on_focus_entered() -> void:
	selected.emit(get_index())


func _on_button_down() -> void:
	activated.emit(get_index())
