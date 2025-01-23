extends Node2D

class_name Dungeon

var dungeon_sample = [
	["█", "I", "-", "-", "-", "-", "█", "█"],
	["█", "█", "█", "-", "T", "-", "-", "█"],
	["█", "-", "-", "-", "-", "-", "O", "█"],
	["█", "█", "-", "T", "-", "-", "█", "█"],
	["█", "█", "█", "-", "-", "█", "█", "█"]
]

## CHILD NODES
@onready var map = $Map
@export var players: Party

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
	player.detector.hit_exit.connect(_on_detector_hit_exit)

	map.display_dungeon()


func player_party_setup():
	for i in players.party:
		i.dungeon_display()
		i.hide()
	player.show()
	players.unfreeze()


## EXIT LOGIC
func exit_dungeon():
	players.freeze()
	var x = await Global.show_text_choice("System", "Do you want to leave the Dungeon?")

	if x == 0:
		print('Yes')
		##RELOAD TOWN
		queue_free()
	elif x == 1:
		print('No')
	players.unfreeze()

func _on_detector_hit_exit(coords) -> void:
	print(coords)
	exit_dungeon()



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
	players.inventory.add_entry(drop)
	print("You got %s!" % [drop.name])


func _on_detector_hit_chest(coords) -> void:
	print(coords)
	collect_treasure()



## BATTLE LOGIC
func _load_enemies():
	_enemy_set = enemy_types.load_all()

func initiate_battle():
	var no_of_enemies = 1 + Global.rand_spread(enemy_spawn_chance, MAX_ENEMIES)

	var battle: Battle = Global.battle_scene.instantiate()
	battle.no_of_enemies = no_of_enemies
	battle.dungeon = self
	battle.players = players
	#player.in_battle = true
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
