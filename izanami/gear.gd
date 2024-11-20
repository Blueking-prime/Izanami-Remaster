extends Node

@export var stats: Dictionary = {"STR": 0, "INT": 0, "WIS": 0, "END": 0, "GUI": 0, "AGI": 0}
var all_gear = JSON.parse_string(FileAccess.open('res://gear.json', FileAccess.READ).get_as_text())

var head_stats = {"STR": 0, "INT": 0, "WIS": 0, "END": 0, "GUI": 0, "AGI": 0}
var body_stats = {"STR": 0, "INT": 0, "WIS": 0, "END": 0, "GUI": 0, "AGI": 0}
var weapon_stats = {"STR": 0, "INT": 0, "WIS": 0, "END": 0, "GUI": 0, "AGI": 0}

func _ready() -> void:
	pass

func equip_gear(gear_name: String):
	for gear in all_gear:
		if gear.get('name') == gear_name:
			match gear.get('slot'):
				'head': head_stats.merge(gear.get('stats'))
				'body': body_stats.merge(gear.get('stats'))
				'weapon': weapon_stats.merge(gear.get('stats'))
