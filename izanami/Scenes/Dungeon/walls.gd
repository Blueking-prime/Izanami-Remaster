extends TileMapLayer

class_name DungeonChunk

@onready var root_node: Dungeon:
	get(): return get_parent().get_parent().get_parent()
@onready var map: DungeonMap:
	get(): return root_node.map
@onready var enemy_types: ResourceGroup:
	get(): return root_node.enemy_types
@onready var background: LocationBackground:
	get(): return root_node.background

var player: Player:
	get(): return Global.players.leader

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

@export var chunk_no: int = 0
@export_flags('Up', 'Down', 'Left', 'Right') var chunk_type: int


var walls: Array[Vector2i]
var chests: Array[Vector2i]
var enemies: Array[Vector2i]
var outer_walls: Array[Vector2i] = []
var enemy_nodes: Array = []

var entrance: Vector2i
var exit: Vector2i

var width: int
var height: int
var marker: Vector2i

var opened_chest_coords: Array = []

func render_objects():
	walls = map.chunks[chunk_no].walls
	chests = map.chunks[chunk_no].treasure_tiles
	enemies = map.chunks[chunk_no].enemy_tiles
	marker = map.chunks[chunk_no].marker

	if not map.chunks[chunk_no].start.is_empty():
		entrance = map.start
		render_entrance()
		place_player()
	if not map.chunks[chunk_no].stop.is_empty():
		exit = map.stop
		render_exit()
	if map.chunks[chunk_no].has('type'):
		chunk_type = map.chunks[chunk_no].type

	height = map.chunk_height
	width = map.chunk_width

	render_treasure_chests()
	render_outer_walls()
	render_inner_walls()

	place_enemies()
	root_node.freeze_enemies()

	set_connections()

	await get_tree().create_timer(0.1).timeout
	root_node.unfreeze_enemies()

	#check_collisions()
	root_node._on_map_loaded()


func set_connections():
	if is_instance_valid(player):
		player.detector.hit_chest.connect(_on_detector_hit_chest)

func place_player():
	var player_pos = entrance * Location.TILEMAP_CELL_SIZE
	if player_pos.x <= 0:
		player_pos.x = Location.TILEMAP_CELL_SIZE * 2
	if player_pos.y <= 0:
		player_pos.y = Location.TILEMAP_CELL_SIZE * 2

	Global.players.global_position = player_pos
	player.global_position = player_pos

func place_enemies():
	var enemy_set = enemy_types.load_all()
	for coord in enemies:
		var _type = randi_range(0, enemy_set.size() - 1)
		var enemy: Enemy = enemy_set[_type].instantiate()

		add_child(enemy)
		enemy.dungeon_display()
		enemy.position = coord * Location.TILEMAP_CELL_SIZE
		enemy.map_size = root_node.size()

	enemy_nodes = get_children()
	#if not root_node.boss_enemy and not enemy_nodes.is_empty():
		#root_node.set_boss(enemy_nodes.pick_random())


func render_treasure_chests():
	for coord in chests: set_cell(coord, treasure_source_id, treasure_atlas_coords)

func render_entrance():
	set_cell(entrance + Vector2i(1, 1), entrance_source_id, entrance_atlas_coords)

func render_exit():
	set_cell(exit + Vector2i(1, 1), exit_source_id, exit_atlas_coords)


func render_inner_walls():
	set_cells_terrain_connect(walls, wall_terrain_set, wall_terrain, false)

func render_outer_walls():
	if chunk_type & DungeonMap.UP: _render_up_walls()
	if chunk_type & DungeonMap.DOWN: _render_down_walls()
	if chunk_type & DungeonMap.LEFT: _render_left_walls()
	if chunk_type & DungeonMap.RIGHT: _render_right_walls()

	if not outer_walls.is_empty():
		set_cells_terrain_connect(outer_walls, wall_terrain_set, wall_terrain, false)


func _render_up_walls():
	for i in range(marker.x, marker.x + width + 1):
		outer_walls.append(Vector2i(i, marker.y))

func _render_down_walls():
	for i in range(marker.x, marker.x + width + 1):
		outer_walls.append(Vector2i(i, marker.y + height))

func _render_left_walls():
	for i in range(marker.y, marker.y + height + 1):
		outer_walls.append(Vector2i(marker.x, i))

func _render_right_walls():
	for i in range(marker.y, marker.y + height + 1):
		outer_walls.append(Vector2i(marker.x + width, i ))


#func check_collisions():
	#Global.players.leader.hitbox.check_overlap(self)
	#for i in enemy_nodes:
		#i.hitbox.check_overlap(self)
#
#func center() -> Vector2:
	#return root_node.center()


func _on_detector_hit_chest(coords) -> void:
	set_cell(coords, treasure_opened_source_id, treasure_opened_atlas_coords)
