class_name Gear

extends Resource

@export_category('Info')
@export var name: String
## Slot gear slots into
@export_enum('head', 'weapon', 'body') var slot: String
## Gear description
@export var desc: String
## Cost of gear
@export var price: int = 0
## Element Gear bestows on user
@export_enum('Physical', 'Fire', 'Water', 'Wind', 'Dark', 'Light', 'Blood',) var element: String
@export_category('Stats')
## Stats the weapon increases and their values
@export var stats: Dictionary[StringName, int] = {"STR": 0, "INT": 0, "WIS": 0, "END": 0, "GUI": 0, "AGI": 0}
## Skills Gear bestows
@export var skills: Array[Skill]
## Resistances Gear bestows on user
@export var resistances: Dictionary[StringName, float] = {
	'Physical':	0,
	'Fire':		0,
	'Water':	0,
	'Wind':		0,
	'Dark':		0,
	'Light':	0,
	'Blood':	0,
}

var equipped: bool = false
var path: String = resource_path
