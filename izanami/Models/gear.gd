extends Node

@export var stats: Dictionary = {"STR": 0, "INT": 0, "WIS": 0, "END": 0, "GUI": 0, "AGI": 0}
@export var player_gear_data: ResourceGroup
var _curr_gear

@export var head: Gear
@export var weapon: Gear
@export var body: Gear

signal gear_change

func _ready() -> void:
	if player_gear_data:
		_curr_gear = player_gear_data.load_all()
		for gear in _curr_gear:
			equip_gear(gear)
			
func equip_gear(gear: Gear):
	match gear.slot:
		'head': head = gear
		'body': body = gear
		'weapon': weapon = gear
	
	_update_total_stats()
	emit_signal('gear_change')

func _update_total_stats():
	for i in stats: stats[i] = 0
	if head:
		for i in stats: stats[i] += head.stats[i]
	if body:
		for i in stats: stats[i] += body.stats[i]
	if weapon:
		for i in stats: stats[i] += weapon.stats[i]
