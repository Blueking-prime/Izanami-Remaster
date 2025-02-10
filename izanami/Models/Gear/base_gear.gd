class_name Gear

extends Resource

@export var name: String
@export var slot: StringName
@export var stats: Dictionary = {"STR": 0, "INT": 0, "WIS": 0, "END": 0, "GUI": 0, "AGI": 0}
@export var desc: String
@export var price: int = 0
@export var equipped: bool = false
@export var skills: ResourceGroup
@export var element: StringName
