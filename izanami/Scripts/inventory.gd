extends Node

var inventory_data: = {}
var inventory: Array = []
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass # Replace with function body.

func add_item(item: Item):
	pass

func add_gear(gear: Gear):
	pass

func add_entry(entry: Variant):
	if entry is Gear:
		add_gear()

func remove_entry(entry: Variant):
	pass
