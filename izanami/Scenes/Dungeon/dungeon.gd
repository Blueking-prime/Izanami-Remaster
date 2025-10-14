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
@export var wall_chunks: WallChunkLoader

#@export var navigation_region: NavigationRegion2D
@export var enemy_display: DungeonEnemyDisplay

## MAP PROPERTIES
@export var width: int = 8
@export var height: int = 5
@export var chunk_length: int = 3
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
@export var max_treasure_no: int = 5

## WORKING VARIABLES
var player: Player:
	get():
		return Global.players.leader

var boss_enemy: Enemy

#var player_pos: Array:
	#get():
		#return [player.position.x / 16, player.position.y / 16]


func load_scene():
	#var start_time = Time.get_ticks_msec()
	#print('Preload ', start_time)
	Global.change_background(Global.loading_screen, true)

	super.load_scene()

	#print('Post super() ', (start_time - Time.get_ticks_msec()) * -1)

	_load_items()

	#print('Pre map create ', (start_time - Time.get_ticks_msec()) * -1)

	map.draw_new_map()
	#map.display_dungeon()
	#print('Pre map render ', (start_time - Time.get_ticks_msec()) * -1)

	background.draw_background()
	wall_chunks.load_chunks(true)

	#setup_navigation_region()
	enemy_display.update_display()
	overlay.save_enabled = false

	Global.change_background(null, true)
	#print('Final time ', (start_time - Time.get_ticks_msec()) * -1)

func connect_signals():
	print('Dungeon sig connected')
	player.detector.hit_chest.connect(_on_detector_hit_chest)
	player.detector.hit_enemy.connect(_on_detector_hit_enemy)
	player.detector.hit_exit.connect(_on_detector_hit_exit)
	player.detector.left_entrance.connect(_on_detector_left_entrance)
	player.detector.left_chunk_border.connect(_on_detector_hit_border)

func disconnect_signals():
	player.detector.hit_chest.disconnect(_on_detector_hit_chest)
	player.detector.hit_enemy.disconnect(_on_detector_hit_enemy)
	player.detector.hit_exit.disconnect(_on_detector_hit_exit)
	player.detector.hit_entrance.disconnect(_on_detector_hit_entrance)
	player.detector.left_chunk_border.disconnect(_on_detector_hit_border)


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

func set_boss(enemy: Enemy):
	boss_enemy = enemy
	boss_enemy.detector.change_colour()


## EXIT LOGIC
func exit_dungeon(completed: bool):
	Global.players.freeze()

	var confirm = await Global.show_confirmation_box("Do you want to leave the Dungeon?")

	Global.players.unfreeze()
	if confirm:
		if completed: Checks.dungeons[dungeon_name].level += 1
		Global.warp(self, Global.town_scene)
	else :
		unfreeze_enemies()

func _on_detector_left_entrance():
	player.detector.left_entrance.disconnect(_on_detector_left_entrance)
	player.detector.hit_entrance.connect(_on_detector_hit_entrance)

func _on_detector_hit_entrance():
	freeze_enemies()
	exit_dungeon(false)

func _on_detector_hit_exit() -> void:
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


func _on_detector_hit_chest() -> void:
	collect_treasure()


## BATTLE LOGIC
func initiate_battle(forced: bool):
	var no_of_enemies = 1 + Global.rand_spread(enemy_spawn_chance, MAX_ENEMIES)
	overlay.hide()

	var battle: Battle = Global.battle_scene.instantiate()
	battle.no_of_enemies = no_of_enemies
	battle.dungeon = self
	battle.enemy_group = enemy_types
	battle.enemy_level = enemy_level
	battle.forced = forced
	#player.in_battle = true
	background.hide()
	objectsort.hide()
	# Slight delay to allow game finich cleaning up resources after previous battle
	#await get_tree().create_timer(1).timeout
	call_deferred("add_sibling", battle)

func freeze_enemies():
	for j in wall_chunks.chunk_tiles:
		if is_instance_valid(j):
			for i in j.enemy_nodes:
				if is_instance_valid(i):
					i.freeze = true
					#i.hitbox.set_deferred('disabled', true)

func unfreeze_enemies():
	for j in wall_chunks.chunk_tiles:
		if is_instance_valid(j):
			for i in j.enemy_nodes:
				if is_instance_valid(i):
					i.freeze = false
					#i.hitbox.disabled = false



func _on_detector_hit_enemy(body: Enemy) -> void:
	Global.players.battle_collision()
	freeze_enemies()
	#Global.push_back_player(body.global_position, 1)
	await get_tree().create_timer(0.5).timeout
	#! USE scene_file_path TO REMEMBERWHAT NODE TO LOAD
	if body == boss_enemy:
		initiate_battle(true)
		tilemap._render_exit()
	else :
		initiate_battle(false)
	if is_instance_valid(body):	body.queue_free()
	#Global.players.battle_reset()
	#reset_from_battle()

func _on_detector_hit_border(chunk):
	wall_chunks.update_player_chunk(chunk)

func reset_from_battle():
	#background.show()
	super.reset_from_battle()
	objectsort.show()
	enemy_display.update_display()
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
	map.load_data(data.map_data)
	tilemap.clear()
	tilemap.load_data(data)

	print('Dungeon data loaded')
