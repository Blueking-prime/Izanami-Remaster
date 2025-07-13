extends Location

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

#@export var navigation_region: NavigationRegion2D
@export var enemy_display: DungeonEnemyDisplay

## MAP PROPERTIES
@export var width: int = 8
@export var height: int = 5
@export var new_map: bool = true
@export var enemy_types: ResourceGroup
@export var MAX_ENEMIES: int = 3
@export var max_enemy_spawns: int = 10
@export var enemy_level: int = 1
@export var dungeon_name: String = 'test'

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
		return Global.players.leader


#var player_pos: Array:
	#get():
		#return [player.position.x / 16, player.position.y / 16]


func load_scene():
	Global.change_background(Global.loading_screen, true)

	super.load_scene()

	_load_items()

	player.detector.hit_chest.connect(_on_detector_hit_chest)
	player.detector.hit_enemy.connect(_on_detector_hit_enemy)
	player.detector.hit_exit.connect(_on_detector_hit_exit)
	player.detector.hit_entrance.connect(_on_detector_hit_entrance)

	if new_map:
		map.draw_new_map()
		#map.display_dungeon()

		tilemap.render_objects()

	#setup_navigation_region()
	enemy_display.update_display()

	Global.change_background(null, true)

#func setup_navigation_region():
	#var vertices = PackedVector2Array([
		#Vector2(0, 0),
		#Vector2(0, height)     * 2 * map.upscale_factor * 16,
		#Vector2(width, height) * 2 * map.upscale_factor * 16,
		#Vector2(width, 0)      * 2 * map.upscale_factor * 16
	#])
#
	#navigation_region.navigation_polygon.clear_outlines()
	#navigation_region.navigation_polygon.add_outline(vertices)
	#NavigationServer2D.bake_from_source_geometry_data(navigation_region.navigation_polygon, NavigationMeshSourceGeometryData2D.new());
#
	#navigation_region.bake_navigation_polygon()

## EXIT LOGIC
func exit_dungeon(completed: bool):
	Global.players.freeze()

	var x = await Global.show_confirmation_box("Do you want to leave the Dungeon?")

	Global.players.unfreeze()
	if x:
		if completed: Checks.dungeon_levels[dungeon_name] += 1
		Global.warp(self, Global.town_scene)
	else :
		unfreeze_enemies()

func _on_detector_hit_entrance(_coords):
	freeze_enemies()
	exit_dungeon(false)

func _on_detector_hit_exit(_coords) -> void:
	freeze_enemies()
	exit_dungeon(true)


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
	Global.players.inventory.add_entry(drop)
	print("You got %s!" % [drop.name])


func _on_detector_hit_chest(_coords) -> void:
	collect_treasure()


## BATTLE LOGIC
func initiate_battle():
	var no_of_enemies = 1 + Global.rand_spread(enemy_spawn_chance, MAX_ENEMIES)
	overlay.hide()

	var battle: Battle = Global.battle_scene.instantiate()
	battle.no_of_enemies = no_of_enemies
	battle.dungeon = self
	battle.enemy_group = enemy_types
	battle.enemy_level = enemy_level
	#player.in_battle = true
	background.hide()
	tilemap.hide()
	# Slight delay to allow game finich cleaning up resources after previous battle
	#await get_tree().create_timer(1).timeout
	call_deferred("add_sibling", battle)

func freeze_enemies():
	for i in tilemap.enemy_nodes:
		if is_instance_valid(i): i.freeze = true

func unfreeze_enemies():
	for i in tilemap.enemy_nodes:
		if is_instance_valid(i): i.freeze = false


func _on_detector_hit_enemy(body: Enemy) -> void:
	freeze_enemies()
	Global.players.freeze()
	Global.push_back_player(body.global_position, 1)
	await get_tree().create_timer(0.5).timeout
	Global.players.leader.hitbox.disabled = true
	#! USE scene_file_path TO REMEMBERWHAT NODE TO LOAD
	initiate_battle()
	body.queue_free()


func reset_from_battle():
	background.show()
	tilemap.show()
	overlay.load_ui_elements()
	enemy_display.update_display()
	overlay.show()
	Global.players.leader.hitbox.disabled = false
	unfreeze_enemies()


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
	save_data.tile_data = tilemap.save()
	save_data.enemy_data = tilemap.save_enemies()

	return save_data

func load_data(data: DungeonSaveData):
	new_map = false
	map.load_data(data.map_data)
	tilemap.clear()
	tilemap.load_data(data)

	print('Dungeon data loaded')
