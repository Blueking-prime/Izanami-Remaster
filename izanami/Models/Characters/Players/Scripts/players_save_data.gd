extends Resource

class_name PartySaveData

@export var gold: int
@export var mag: int
@export var dungeon_level: int

@export var players: Array[PlayerSaveData] = []

@export var inventory_data: ResourceGroup

@export var position: Vector2
