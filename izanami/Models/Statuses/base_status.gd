extends Resource

class_name Status

@export var duration: int = 1
@export var elapsed: int
@export var delay: int = 0
@export var desc: String
@export var icon: Texture2D = load("res://addons/godot_resource_groups/resource_group.svg")
@export var extra_prop: Variant

func trigger(_victim: Base_Character):
	elapsed += 1
