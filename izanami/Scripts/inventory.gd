extends Node

@export var item_group: ResourceGroup
@export var gear_group: ResourceGroup

var inventory_data: Dictionary = {}
var inventory: Array = []
var items: Array = []
var gear: Array = []


func add_entry(entry: Variant):
	if entry is Gear:
		gear.append(entry)
	elif entry is Item:
		items.append(entry)

	inventory.append(entry)
	if entry.name in inventory_data:
		inventory_data[entry.name] += 1
	else:
		inventory_data.get_or_add(entry.name, 1)


func remove_entry(entry: Variant):
	inventory.erase(entry)
	if entry is Gear:
		gear.erase(entry)
	elif entry is Item:
		items.erase(entry)

	inventory_data[entry.name] -= 1
	if inventory_data[entry.name] <= 0:
		inventory_data.erase(entry.name)

func get_entry_by_name(entry: String):
	for i in inventory:
		if i.name == entry:
			remove_entry(i)
			return i
