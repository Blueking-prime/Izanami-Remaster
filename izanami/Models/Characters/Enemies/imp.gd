extends Enemy

@export var enemy_atk_lines: Array = ["The Imp slashes at you with improvised weapons and you take"]
@export var enemy_element: StringName = 'Fire'
@export var enemy_stats: Dictionary = {"STR": 3, "INT": 3, "WIS": 2, "END": 4, "GUI": 2, "AGI": 2}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_stats = enemy_stats
	atk_lines = enemy_atk_lines
	element = enemy_element
	super()
