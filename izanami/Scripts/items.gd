extends Node

@export var item_group: ResourceGroup
@export var _item_dict: Dictionary

var inventory: Inventory


func _ready() -> void:
	inventory = get_parent().get_node("../Inventory")
	if item_group:
		for i in item_group.load_all():
			add_item(i)

	if inventory:
		_item_dict = inventory.item_data


func add_item(item: Item):
	if item.name in _item_dict:
		_item_dict[item.name].append(item)
	else:
		_item_dict.get_or_add(item.name, [item])

	if inventory:
		inventory.add_entry(item)

func get_item(item_name: String):
	return _item_dict[item_name][0]

func remove_item(item: Item):
	_item_dict[item.name].erase(item)
	if not len(_item_dict[item.name]):
		_item_dict.erase(item.name)

func get_items():
	return _item_dict
