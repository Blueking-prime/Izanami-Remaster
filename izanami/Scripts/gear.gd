extends Node

@export var stats: Dictionary = {"STR": 0, "INT": 0, "WIS": 0, "END": 0, "GUI": 0, "AGI": 0}
@export var player_gear_data: ResourceGroup
var _curr_gear
var inventory

@export var head: Gear
@export var weapon: Gear
@export var body: Gear

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
	match gear.slot:
		'head':
			if head:
				head.equipped = false
			head = gear
			head.equipped = true
		'body':
			if body:
				body.equipped = false
			body = gear
			body.equipped = true
		'weapon':
			if weapon:
				weapon.equipped = false
			weapon = gear
			weapon.equipped = true

	_update_total_stats()
	get_parent().update_stats()

	for i in [head, body, weapon]:
		if i:
			print(i.name, ' ')
		else:
			print(i, ' ')

func _update_total_stats():
	for i in stats: stats[i] = 0
	if head:
		for i in stats: stats[i] += head.stats[i]
	if body:
		for i in stats: stats[i] += body.stats[i]
	if weapon:
		for i in stats: stats[i] += weapon.stats[i]
