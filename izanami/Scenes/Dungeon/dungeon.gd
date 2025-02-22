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
@export var map: DungeonMap
@export var background: DungeonBackground
@export var walls: DungeonObjects

@export var players: Party

@export var overlay: UIOverlay
@export var camera: Camera2D

## MAP PROPERTIES
@export var width: int = 8
@export var height: int = 5
@export var new_map: bool = true
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
var player: Player:
	get():
		return players.leader


#var player_pos: Array:
	#get():
		#return [player.position.x / 16, player.position.y / 16]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_scene()

func load_scene():
	if not Global.player_party:
		Global.player_party = players
	else:
		players = Global.player_party

	player_party_setup()
	_load_items()
	#_load_enemies()

	player.detector.hit_chest.connect(_on_detector_hit_chest)
	player.detector.hit_enemy.connect(_on_detector_hit_enemy)
	player.detector.hit_exit.connect(_on_detector_hit_exit)

	if new_map:
		map.draw_new_map()
		map.display_dungeon()

		walls.render_objects()

	background.draw_background()

	overlay.load_ui_elements()

	camera.players = players
	camera.init_camera()

func player_party_setup():
	players.show()
	for i in players.party:
		i.dungeon_display()
		i.hide()
	player.show()
	players.unfreeze()


## EXIT LOGIC
func exit_dungeon():
	players.freeze()
	var x = await Global.show_text_choice("System", "Do you want to leave the Dungeon?")

	players.unfreeze()
	if x == 0:
		print('Yes')
		load_town()
		queue_free()
	elif x == 1:
		print('No')

func load_town():
	var town = Global.town_scene.instantiate()
	print(town)
	var town_players = town.get_node("Players")
	town.remove_child(town_players)
	town.players = players

	get_node('ObjectsSort').remove_child(players)
	town.add_child(players)
	add_sibling(town)
	get_tree().current_scene = town

	player.position = Vector2(1657, 264 + 90)

	print(get_tree().current_scene)

	print('Town Loaded')


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
func initiate_battle():
	var no_of_enemies = 1 + Global.rand_spread(enemy_spawn_chance, MAX_ENEMIES)
	overlay.hide()

	var battle: Battle = Global.battle_scene.instantiate()
	battle.no_of_enemies = no_of_enemies
	battle.dungeon = self
	battle.players = players
	battle.enemy_group = enemy_types
	#player.in_battle = true
	get_node("Background").hide()
	get_node("ObjectsSort/Walls").hide()
	call_deferred("add_sibling", battle)


func _on_detector_hit_enemy(body: Enemy) -> void:
	print(body)
	#! USE scene_file_path TO REMEMBERWHAT NODE TO LOAD
	initiate_battle()
	body.queue_free()


func reset_from_battle():
	get_node("Background").show()
	get_node("ObjectsSort/Walls").show()
	overlay.load_ui_elements()
	overlay.show()


## SAVE AND LOAD LOGIC
func save() -> DungeonSaveData:
	var save_data: DungeonSaveData = DungeonSaveData.new()

	save_data.width = width
	save_data.height = height
	save_data.enemy_types = enemy_types
	save_data.item_drop_group = item_drop_group
	save_data.gear_drop_group = gear_drop_group
	save_data.MAX_ENEMIES = MAX_ENEMIES
	save_data.enemy_spawn_chance = enemy_spawn_chance
	save_data.treasure_spawn_chance = treasure_spawn_chance
	save_data.gear_chance = gear_chance

	save_data.map_data = map.save()
	save_data.tile_data = walls.save()
	save_data.enemy_data = walls.save_enemies()

	return save_data

func load_data(data: DungeonSaveData):
	new_map = false
	map.load_data(data.map_data)
	walls.clear()
	walls.load_data(data)

	print('Dungeon data loaded')
