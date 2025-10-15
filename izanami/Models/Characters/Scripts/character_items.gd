extends Node

class_name CharacterItems


@export var item_group: ResourceGroup
@export var _item_dict: Dictionary[StringName, Array]

var inventory: Inventory:
	get():
		if get_parent().get_parent() is Party: return get_parent().get_parent().inventory
		else: return null


func load_stock() -> void:
	#if get_parent().has_node("../Inventory"):
		#inventory = get_parent().get_node("../Inventory")
	if item_group:
		for i in item_group.load_all():
			add_item(i)

	#if inventory:
		#_item_dict = inventory.item_data


func add_item(item: Item):
	if inventory:
		inventory.add_entry(item)
	else:
		if item.name in _item_dict:
			_item_dict[item.name].append(item)
		else:
			_item_dict.get_or_add(item.name, [item])

func get_item(item_name: String) -> Item:
	if inventory:
		return inventory.get_entry_by_name(item_name)
	elif _item_dict.has(item_name):
		return _item_dict[item_name][0]
	else:
		return null

func remove_item(item: Item):
	if inventory:
		inventory.remove_entry(item)
	elif _item_dict.has(item.name):
		_item_dict[item.name].erase(item)
		if _item_dict[item.name].is_empty():
			_item_dict.erase(item.name)

func get_items():
	if inventory:
		return inventory.item_data
	else:
		return _item_dict
