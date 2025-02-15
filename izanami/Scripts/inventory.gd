extends Node

class_name Inventory

@export var item_group: ResourceGroup
@export var gear_group: ResourceGroup

var inventory_data: Dictionary = {}
var item_data: Dictionary = {}
var gear_data: Dictionary = {}

# data format: {item_name: [items]}

func load_stock(data: ResourceGroup):
	inventory_data = {}
	item_data = {}
	gear_data = {}

	for i in data.load_all():
		print(i.name)
		add_entry(i)

func add_entry(entry: Variant):
	if entry is Gear:
		if entry.name in gear_data:
			gear_data[entry.name].append(entry)
		else:
			gear_data.get_or_add(entry.name, [entry])
	elif entry is Item:
		if entry.name in item_data:
			item_data[entry.name].append(entry)
		else:
			item_data.get_or_add(entry.name, [entry])

	if entry.name in inventory_data:
		inventory_data[entry.name].append(entry)
	else:
		inventory_data.get_or_add(entry.name, [entry])

func remove_entry(entry: Variant):
	if entry is Gear:
		gear_data[entry.name].erase(entry)
	elif entry is Item:
		item_data[entry.name].erase(entry)

	inventory_data[entry.name].erase(entry)
	if not len(inventory_data[entry.name]):
		inventory_data.erase(entry.name)

func get_entry_by_name(entry: String):
	var value
	if entry in inventory_data:
		if len(inventory_data[entry]):
			value = inventory_data[entry][0]

	# Prefer non-equipped gear:
	if value is Gear:
		for i in inventory_data[entry]:
			if not i.equipped:
				value = i
				break

	return value

func get_count(entry: Variant):
	if entry is String:
		return len(inventory_data[entry])
	else:
		return len(inventory_data[entry.name])

func save_stock() -> ResourceGroup:
	var save_data: ResourceGroup = ResourceGroup.new()

	for i in inventory_data:
		for j in inventory_data[i]:
			if j is Gear:
				if not j.equipped:
					print("GEAR APPENDED", j.name)
					save_data.paths.append(j.path)
				continue
			print("ITEM APPENDED", j.name)
			save_data.paths.append(j.resource_path)

	return save_data
