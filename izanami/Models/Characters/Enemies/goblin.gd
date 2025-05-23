extends Enemy

@export var enemy_atk_lines: Array = ["The Goblin slashes at you with its claws and you take"]
@export var enemy_stats: Dictionary = {"STR": 1, "INT": 1, "WIS": 0, "END": 2, "GUI": 0, "AGI": 0}
@export var enemy_resistances: Dictionary = {
	'Physical':	0,
	'Fire':		-0.5,
	'Water':	0,
	'Wind':		0,
	'Dark':		0,
	'Light':	-0.5,
	'Blood':	0,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	root_stats = enemy_stats
	atk_lines = enemy_atk_lines
	resistances = enemy_resistances
	super()
