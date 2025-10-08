extends TileMapLayer

# class_name DungeonObjects


@onready var root_node: Dungeon:
	get():
		return get_parent().get_parent().get_parent()
@onready var map: DungeonMap:
	get():
		return root_node.map
@onready var enemy_types: ResourceGroup:
	get():
		return root_node.enemy_types

var player: Player:
	get():
		return Global.players.leader

@export var background: LocationBackground
@export var wall_upper_layers: Array[DungeonWallsLayer]

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
var chests: Array[Vector2i]
var enemies: Array[Vector2i]
var entrance: Vector2i
var exit: Vector2i
var enemy_nodes: Array = []
var width: int
var height: int
var upscale_factor: int

var opened_chest_coords: Array = []

func render_objects():
	walls = map.walls[0]
	chests = map.treasure_tiles
	enemies = map.enemy_tiles
	entrance = map.start
	exit = map.stop
	height = map.height
	width = map.width
	upscale_factor = map.upscale_factor
	#print('walls = ', walls)

	background.draw_background()
	_render_treasure_chests()
	_render_outer_walls()
	_render_inner_walls()
	_render_entrance()
	for i in wall_upper_layers:
		i.render_objects()

	#_render_exit()
	_place_enemies()
	root_node.freeze_enemies()

	place_player()

	set_connections()

	await get_tree().create_timer(0.1).timeout
	root_node.unfreeze_enemies()

	check_collisions()
	root_node._on_map_loaded()

func set_connections():
	if is_instance_valid(player):
		player.detector.hit_chest.connect(_on_detector_hit_chest)


func place_player():
	var player_pos = entrance * Location.TILEMAP_CELL_SIZE
	if player_pos.x <= 0:
		player_pos.x = Location.TILEMAP_CELL_SIZE
	if player_pos.y <= 0:
		player_pos.y = Location.TILEMAP_CELL_SIZE

	Global.players.global_position = player_pos
	player.global_position = player_pos

func _place_enemies():
	var enemy_set = enemy_types.load_all()
	for coord in enemies:
		var _type = randi_range(0, enemy_set.size() - 1)
		var enemy: Enemy = enemy_set[_type].instantiate()

		add_child(enemy)
		enemy.dungeon_display()
		enemy.position = coord * upscale_factor * Location.TILEMAP_CELL_SIZE
		enemy.map_size = root_node.size()
		print(enemy.map_size)

	enemy_nodes = get_children()
	if not root_node.boss_enemy and not enemy_nodes.is_empty():
		root_node.set_boss(enemy_nodes.pick_random())


func _render_outer_walls():
	var outer_walls: Array[Vector2i] = []
	for i in range(-1, upscale_factor * height):
		#var wall_block_left
		outer_walls.append_array([
			Vector2i(0            , i),
			Vector2i(0            , i + 1),
			Vector2i(-1           , i),
			Vector2i(-1           , i + 1),
			Vector2i(upscale_factor * width - 1, i),
			Vector2i(upscale_factor * width - 1, i + 1),
			Vector2i(upscale_factor * width    , i),
			Vector2i(upscale_factor * width    , i + 1),
		])

	for i in range(-1, upscale_factor * width):
		outer_walls.append_array([
			Vector2i(i    , -1),
			Vector2i(i + 1, -1),
			Vector2i(i    , 0),
			Vector2i(i + 1, 0),
			Vector2i(i    , upscale_factor * height),
			Vector2i(i + 1, upscale_factor * height),
			Vector2i(i    , upscale_factor * height - 1),
			Vector2i(i + 1, upscale_factor * height - 1),
		])

	set_cells_terrain_connect(outer_walls, wall_terrain_set, wall_terrain, false)

func _render_inner_walls():
	var walls_vector_array: Array[Vector2i] = []
	for coord in walls:
		walls_vector_array.append(coord * upscale_factor)
		if upscale_factor > 1:
			walls_vector_array.append_array([
				coord * upscale_factor + Vector2i.LEFT,
				coord * upscale_factor + Vector2i.DOWN,
				coord * upscale_factor + Vector2i.LEFT + Vector2i.DOWN,
			])

	set_cells_terrain_connect(walls_vector_array, wall_terrain_set, wall_terrain, false)

func _render_treasure_chests():
	for coord in chests:
		set_cell(
			coord * upscale_factor,
			treasure_source_id,
			treasure_atlas_coords
		)

func _render_entrance():
	set_cell(
		entrance * upscale_factor + Vector2i(1, 1),
		entrance_source_id,
		entrance_atlas_coords
	)

func _render_exit():
	set_cell(
		exit * upscale_factor + Vector2i(1, 1),
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

	await get_tree().create_timer(0.1).timeout
	check_collisions()

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

func check_collisions():
	Global.players.leader.hitbox.check_overlap(self)
	for i in enemy_nodes:
		i.hitbox.check_overlap(self)

func center() -> Vector2:
	return root_node.center()

#Test
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		print("Player is at", player.global_position)
