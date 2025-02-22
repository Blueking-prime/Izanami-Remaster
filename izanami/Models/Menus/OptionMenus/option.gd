extends Button

class_name Option

@export var option_name: Label
@export var quantity_1: Label
@export var quantity_2: Label
@export var quantity_3: Label
@export var quantity_4: Label
@export var quantity_5: Label

signal activated(index: int)
signal selected(index: int)

func _on_pressed() -> void:
	activated.emit(get_index())


func _on_focus_entered() -> void:
	selected.emit(get_index())
