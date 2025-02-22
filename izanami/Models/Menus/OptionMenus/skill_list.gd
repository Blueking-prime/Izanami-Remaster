extends HBoxContainer

class_name SkillMenu

@export var list: ItemList
@export var cost: ItemList

signal item_selected(index: int)
signal item_activated(index: int)

func clear():
	list.clear()
	cost.clear()

func _on_item_selected(index: int) -> void:
	list.select(index)
	cost.select(index)
	item_selected.emit(index)

func _on_item_activated(index: int) -> void:
	item_activated.emit(index)
