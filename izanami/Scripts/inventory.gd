extends Node

class_name Inventory

@export var item_group: ResourceGroup
@export var gear_group: ResourceGroup

var inventory_data: Dictionary[StringName, Array] = {}
var item_data: Dictionary[StringName, Array] = {}:
	get(): return _filter_item_data()
var gear_data: Dictionary[StringName, Array]  = {}:
	get(): return _filter_gear_data()

# data format: {item_name: [items]}

func _filter_gear_data() -> Dictionary[StringName, Array]:
	var _new_dict: Dictionary[StringName, Array]
	for i in inventory_data: if inventory_data[i].front() is Gear: _new_dict[i] = inventory_data[i]
	return _new_dict

func _filter_item_data() -> Dictionary[StringName, Array]:
	var _new_dict: Dictionary[StringName, Array]
	for i in inventory_data: if inventory_data[i].front() is Item: _new_dict[i] = inventory_data[i]
	return _new_dict


func load_stock(data: ResourceGroup):
	inventory_data = {}

	for i in data.load_all():
		add_entry(i)

func add_entry(entry: Variant):
	#if entry is Gear:
		#if entry.name in gear_data:
			#gear_data[entry.name].append(entry)
		#else:
			#gear_data.get_or_add(entry.name, [entry])
	#elif entry is Item:
		#if entry.name in item_data:
			#item_data[entry.name].append(entry)
		#else:
			#item_data.get_or_add(entry.name, [entry])

	if entry.name in inventory_data:
		inventory_data[entry.name].append(entry)
	else:
		inventory_data.get_or_add(entry.name, [entry])

func remove_entry(entry: Variant):
	#if entry is Gear:
		#gear_data[entry.name].erase(entry)
		#if gear_data[entry.name].is_empty():
			#gear_data.erase(entry.name)
	#elif entry is Item:
		#item_data[entry.name].erase(entry)
		#if item_data[entry.name].is_empty():
			#item_data.erase(entry.name)

	inventory_data[entry.name].erase(entry)
	if inventory_data[entry.name].is_empty():
		inventory_data.erase(entry.name)

func get_entry_by_name(entry: String):
	var value
	if entry in inventory_data:
		if not inventory_data[entry].is_empty():
			value = inventory_data[entry].front()

	# Prefer non-equipped gear:
	if value is Gear:
		for i in inventory_data[entry]:
			if not i.equipped:
				value = i
				break

	return value

func get_count(entry: Variant):
	if entry is String:
		return inventory_data[entry].size()
	else:
		return inventory_data[entry.name].size()

func save_stock() -> ResourceGroup:
	var save_data: ResourceGroup = ResourceGroup.new()

	for i in inventory_data:
		for j in inventory_data[i]:
			if j is Gear:
				if not j.equipped:
					save_data.paths.append(j.path)
				continue
			save_data.paths.append(j.resource_path)

	return save_data
