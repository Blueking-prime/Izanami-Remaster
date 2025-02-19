extends TileMapLayer

class_name DungeonObjects

@onready var map: DungeonMap = get_parent().get_parent().map

@onready var player: Player = get_parent().get_parent().player
@onready var players: Party = get_parent().get_parent().players
@onready var enemy_types: ResourceGroup = get_parent().get_parent().enemy_types

@export var treasure_atlas_coords: Vector2i
@export var treasure_source_id: int
@export var treasure_opened_atlas_coords: Vector2i
@export var treasure_opened_source_id: int
@export var entrance_atlas_coords: Vector2i
@export var entrance_source_id: int
@export var exit_atlas_coords: Vector2i
@export var exit_source_id: int
@export var wall_terrain_set: int
@export var wall_terrain: int

var walls: Array
var chests: Array
var enemies: Array
var entrance: Array
var exit: Array
var enemy_nodes
var width
var height

var opened_chest_coords: Array = []

func render_objects():
	walls = map.walls
	chests = map.treasure_tiles
	enemies = map.enemy_tiles
	entrance = map.start
	exit = map.stop
	height = map.height
	width = map.width
	#print('walls = ', walls)

	_render_treasure_chests()
	_render_inner_walls()
	_render_outer_walls()
	_render_entrance()
	_render_exit()
	_place_enemies()
	place_player()

	set_connections()

func set_connections():
	if is_instance_valid(player):
		player.detector.hit_chest.connect(_on_detector_hit_chest)

func place_player():
	var player_pos = Vector2i(entrance[0] * 16, entrance[1] * 16)
	if player_pos.x <= 0:
		player_pos.x = 16
	if player_pos.y <= 0:
		player_pos.y = 16

	players.position = player_pos
	player.position = player_pos

func _place_enemies():
	var enemy_set = enemy_types.load_all()
	for coord in enemies:
		var _type = randi_range(0, enemy_set.size() - 1)
		var enemy: Enemy = enemy_set[_type].instantiate()

		add_child(enemy)
		enemy.dungeon_display()
		enemy.position = Vector2i(2*16*coord[0], 2*16*coord[1])

	enemy_nodes = get_children()

func _render_outer_walls():
	var outer_walls = []
	for i in range(-1, 2 * height):
		outer_walls.append_array([
			Vector2i(-1       , i),
			Vector2i(-1       , i + 1),
			Vector2i(2 * width, i),
			Vector2i(2 * width, i + 1)
		])
	for i in range(-1, 2 * width):
		outer_walls.append_array([
			Vector2i(i    , -1),
			Vector2i(i + 1, -1),
			Vector2i(i    , 2 * height),
			Vector2i(i + 1, 2 * height)
		])

	set_cells_terrain_connect(outer_walls, wall_terrain_set, wall_terrain, false)

func _render_inner_walls():
	var walls_vector_array = []
	var x
	var y
	for coord in walls:
		x = coord[0]
		y = coord[1]
		walls_vector_array.append_array([
				Vector2i(2 * x,     2 * y),
				Vector2i(2 * x,     2 * y + 1),
				Vector2i(2 * x + 1, 2 * y),
				Vector2i(2 * x + 1, 2 * y + 1)
				])

	set_cells_terrain_connect(walls_vector_array, wall_terrain_set, wall_terrain, false)

func _render_treasure_chests():
	for coord in chests:
		set_cell(
			Vector2i(2 * coord[0], 2 * coord[1]),
			treasure_source_id,
			treasure_atlas_coords
		)

func _render_entrance():
	set_cell(
		Vector2i(2 * entrance[0] + 1, 2 * entrance[1] + 1),
		entrance_source_id,
		entrance_atlas_coords
	)

func _render_exit():
	set_cell(
		Vector2i(2 * exit[0] + 1, 2 * exit[1] + 1),
		exit_source_id,
		exit_atlas_coords
	)


func _swap_chest_state(coords):
	set_cell(
			coords,
			treasure_opened_source_id,
			treasure_opened_atlas_coords
		)
	opened_chest_coords.append(coords)

func _on_detector_hit_chest(coords) -> void:
	_swap_chest_state(coords)


func save() -> TileMapPattern:
	return get_pattern(get_used_cells())

func load_data(data: DungeonSaveData):
	load_tiles(data.tile_data)
	load_enemies(data.enemy_data)
	set_connections()

func save_enemies() -> Array[CharacterSaveData]:
	var enemy_data: Array[CharacterSaveData] = []
	for i in enemy_nodes:
		enemy_data.append(i.save())
	return enemy_data

func load_tiles(pattern: TileMapPattern):
	set_pattern(Vector2i(), pattern)

func load_enemies(enemy_data: Array[CharacterSaveData]):
	if enemy_nodes: for i in enemy_nodes:
		remove_child(i)
		i.queue_free()

	for i in enemy_data:
		var enemy: Enemy = load(i.scene_file_path).instantiate()
		enemy.load_data(i)
		enemy.dungeon_display()
		add_child(enemy)
