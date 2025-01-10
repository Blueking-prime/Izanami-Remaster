extends Node2D

class_name Dungeon

var dungeon_sample = [
	["█", "I", "-", "-", "-", "-", "█", "█"],
	["█", "█", "█", "-", "T", "-", "-", "█"],
	["█", "-", "-", "-", "-", "-", "O", "█"],
	["█", "█", "-", "T", "-", "-", "█", "█"],
	["█", "█", "█", "-", "-", "█", "█", "█"]
]

@onready var battle_scene: PackedScene = preload("res://Scenes/battle.tscn")

## CHILD NODES
@onready var map = $Map
@export var players: Node2D

## MAP PROPERTIES
@export var width: int = 8
@export var height: int = 5
@export var enemy_types: ResourceGroup
@export var MAX_ENEMIES: int = 3

## DROPS
@export var item_drop_group: ResourceGroup
@export var gear_drop_group: ResourceGroup
var _gear_drops = []
var _item_drops = []

## DROP RATES
@export var enemy_spawn_chance: float = 0.8
@export var treasure_spawn_chance: float = 0.2
@export var gear_chance: float = 0.5

## WORKING VARIABLES
var _enemy_set
var player: Player:
	get():
		return players.leader

#var player_pos: Array:
	#get():
		#return [player.position.x / 16, player.position.y / 16]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_party_setup()
	_load_items()
	#_load_enemies()

	player.detector.hit_chest.connect(_on_detector_hit_chest)
	player.detector.hit_enemy.connect(_on_detector_hit_enemy)

	map.display_dungeon()


func player_party_setup():
	for i in players.party:
		i.hide()
	player.show()


## EXIT LOGIC
func exit_dungeon():
	var x = Global.dialog_choice("Do you want to leave the Dungeon?", false)
	if x:
		pass

	#unload all resources
	for i in _gear_drops:
		i.free()
	for i in _item_drops:
		i.free()




## TREASURE LOGIC
func _load_items():
	_gear_drops = gear_drop_group.load_all()
	_item_drops = item_drop_group.load_all()


func collect_treasure():
	var x
	var index
	var drop
	if Global.rand_chance(gear_chance):
		x = _gear_drops
	else:
		x = _item_drops

	print(x)

	index = randi_range(0, len(x) - 1)
	drop = x[index]

	print(drop)
	var u = Inventory.add_item(drop.name)
	print(Inventory.item_count)
	print(Inventory.get_item_text(u))
	print("You got %s!" % [drop.name])


func _on_detector_hit_chest(coords) -> void:
	print(coords)
	collect_treasure()



## BATTLE LOGIC
func _load_enemies():
	_enemy_set = enemy_types.load_all()

func initiate_battle():
	var no_of_enemies = 1 + Global.rand_spread(enemy_spawn_chance, MAX_ENEMIES)

	var battle: Battle = battle_scene.instantiate()
	battle.no_of_enemies = no_of_enemies
	battle.dungeon = self
	battle.players = players
	player.in_battle = true
	get_node("Background").hide()
	get_node("ObjectsSort/Walls").hide()
	call_deferred("add_sibling", battle)


func _on_detector_hit_enemy(body: Variant) -> void:
	print(body)
	initiate_battle()
	body.queue_free()

func reset_from_battle():
	get_node("Background").show()
	get_node("ObjectsSort/Walls").show()
