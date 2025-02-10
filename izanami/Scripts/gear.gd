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

func load_stock() -> void:
	inventory = get_parent().get_node("../Inventory")

	if player_gear_data:
		_curr_gear = player_gear_data.load_all()
		if inventory:
			for i in _curr_gear:
				inventory.add_entry(i)
		for gear in _curr_gear:
			equip_gear(gear)

func check_equipped(gear: Gear) -> bool:
	for i in gear_dict:
		if gear_dict[i] and gear_dict[i].name == gear.name:
			return true

	return false

func equip_gear(gear: Gear):
	if gear_dict[gear.slot]:
		gear_dict[gear.slot].equipped = false

		# Remove any skills associated with this gear
		if gear_dict[gear.slot].skills:
			for i in gear_dict[gear.slot].skills:
				get_parent().skills.remove_skill(i)

	gear_dict[gear.slot] = gear
	gear_dict[gear.slot].equipped = true

	if gear.skills:
		for i in gear.skills:
			get_parent().skills.add_skill(i)

	_update_total_stats()
	get_parent().update_stats()

func unequip_gear(slot: String):
	if gear_dict[slot]:
		gear_dict[slot].equipped = false

		# Remove any skills associated with this gear
		if gear_dict[slot].skills:
			for i in gear_dict[slot].skills:
				get_parent().skills.remove_skill(i)

	gear_dict[slot] = null

	_update_total_stats()
	get_parent().update_stats()


func _update_total_stats():
	for i in stats: stats[i] = 0

	for i in gear_dict:
		if gear_dict[i]: for j in stats: stats[j] += gear_dict[i].stats[j]
