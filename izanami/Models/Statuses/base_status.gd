extends Resource

class_name Status

@export var duration: int = 1
@export var elapsed: int
@export var desc: String
@export var icon: Texture2D = load("res://addons/godot_resource_groups/resource_group.svg")

func trigger(_victim: Base_Character):
	elapsed += 1
