extends CharacterSaveData

class_name PlayerSaveData

@export var sp: int
@export var xp: int
@export var character_name: String
@export var classname: StringName
@export var lock: bool

@export var base_stats: Dictionary[StringName, int]

@export var gear: ResourceGroup
@export var skills: Array[Skill]
