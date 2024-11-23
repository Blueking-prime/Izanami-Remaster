class_name Skill

extends Resource

@export var name: StringName
@export var stats: Array[StringName] = []
@export var stat_multiplier: int = 1
@export var cost: int = 0
@export var boost: Array = [1, 1]
@export var flavour_text: String = ''
@export var element: StringName = ''
@export var status_effect: Array
@export var effect: Callable
