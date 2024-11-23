extends Node

@export var stats: Dictionary = {"STR": 0, "INT": 0, "WIS": 0, "END": 0, "GUI": 0, "AGI": 0}
@export_file('*.json') var gear_location: String
var all_gear

@export var head_stats = {"STR": 0, "INT": 0, "WIS": 0, "END": 0, "GUI": 0, "AGI": 0}
@export var body_stats = {"STR": 0, "INT": 0, "WIS": 0, "END": 0, "GUI": 0, "AGI": 0}
@export var weapon_stats = {"STR": 0, "INT": 0, "WIS": 0, "END": 0, "GUI": 0, "AGI": 0}

@export var head: StringName
@export var weapon: StringName
@export var body: StringName

signal gear_change

func _ready() -> void:
	all_gear = JSON.parse_string(FileAccess.open(gear_location, FileAccess.READ).get_as_text())
	equip_gear(head)
	equip_gear(weapon)
	equip_gear(body)


func equip_gear(gear_name: String):
	for gear in all_gear:
		if gear.get('name') == gear_name:
			var gear_stats = gear.get('stats')
			match gear.get('slot'):
				'head': for i in gear_stats: head_stats[i] = gear_stats[i]
				'body': for i in gear_stats: body_stats[i] = gear_stats[i]
				'weapon': for i in gear_stats: weapon_stats[i] = gear_stats[i]
	
	_update_total_stats()
	emit_signal('gear_change')

func _update_total_stats():
	for i in stats:
		stats[i] = head_stats[i] + weapon_stats[i] + body_stats[i]
