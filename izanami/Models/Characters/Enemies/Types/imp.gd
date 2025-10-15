extends Enemy

@export var enemy_atk_lines: Array = []
@export var enemy_stats: Dictionary[StringName, int] = {"STR": 3, "INT": 3, "WIS": 2, "END": 4, "GUI": 2, "AGI": 2}
@export var enemy_resistances: Dictionary[StringName, float] = {
	'Physical':	0,
	'Fire':		0,
	'Water':	-0.5,
	'Wind':		0,
	'Dark':		0,
	'Light':	0,
	'Blood':	0,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	root_stats = enemy_stats
	atk_lines = enemy_atk_lines
	resistances = enemy_resistances
	super()
