extends Resource

class_name DungeonSaveData

@export var location: StringName = 'Dungeon'

@export var width: int
@export var height: int
@export var enemy_types: ResourceGroup
@export var item_drop_group: ResourceGroup
@export var gear_drop_group: ResourceGroup
@export var MAX_ENEMIES: int
@export var enemy_spawn_chance: int
@export var treasure_spawn_chance: int
@export var gear_chance: int

@export var map_data: DungeonMapSaveData
@export var tile_data: TileMapPattern
@export var enemy_data: Array[CharacterSaveData]
