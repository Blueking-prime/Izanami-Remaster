extends Enemy

@export var enemy_atk_lines: Array = []
@export var enemy_element: StringName = 'Fire'
@export var enemy_stats: Dictionary = {"STR": 3, "INT": 3, "WIS": 2, "END": 4, "GUI": 2, "AGI": 2}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	root_stats = enemy_stats
	atk_lines = enemy_atk_lines
	element = enemy_element
	super()
