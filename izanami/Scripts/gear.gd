extends Node

class_name PlayerGear

@export var stats: Dictionary = {"STR": 0, "INT": 0, "WIS": 0, "END": 0, "GUI": 0, "AGI": 0}
@export var player_gear_data: ResourceGroup
var _curr_gear
var inventory

@export var gear_dict: Dictionary = {
	'head': null,
	'weapon': null,
	'body': null
}

func _ready() -> void:
	inventory = get_parent().get_node("../Inventory")

	if player_gear_data:
		_curr_gear = player_gear_data.load_all()
		if inventory:
			for i in _curr_gear:
				inventory.add_entry(i)
		for gear in _curr_gear:
			equip_gear(gear)

func equip_gear(gear: Gear):
	if gear_dict[gear.slot]:
		gear_dict[gear.slot].equipped = false
	gear_dict[gear.slot] = gear
	gear_dict[gear.slot].equipped = true

	_update_total_stats()
	get_parent().update_stats()

func _update_total_stats():
	for i in stats: stats[i] = 0

	for i in gear_dict:
		if gear_dict[i]: for j in stats: stats[j] += gear_dict[i].stats[j]
