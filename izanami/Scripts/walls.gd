extends TileMapLayer

@onready var width: int = get_parent().get_parent().width
@onready var height: int = get_parent().get_parent().height
@onready var player: Player = get_parent().get_parent().player

@onready var enemy_scene: PackedScene = preload("res://Models/Characters/Enemies/enemy.tscn")

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

@onready var map: Node = $"../../Map"

func _ready() -> void:
	walls = map.walls
	chests = map.treasure_tiles
	enemies = map.enemy_tiles
	entrance = map.start
	exit = map.stop
	#print('walls = ', walls)

	player.detector.hit_chest.connect(_on_detector_hit_chest)

	_render_treasure_chests()
	_render_inner_walls()
	_render_outer_walls()
	_render_entrance()
	_render_exit()
	_place_enemies()
	_place_player()


func _place_player():
	player.dungeon_display()
	player.position = Vector2i(2*16*entrance[0], 2*16*entrance[1])
	print(player.position)
	print(entrance)

func _place_enemies():
	for coord in enemies:
		var enemy = enemy_scene.instantiate()
		add_child(enemy)
		enemy.dungeon_display()
		enemy.position = Vector2i(2*16*coord[0], 2*16*coord[1])
		print(enemy.position)

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

func _on_detector_hit_chest(coords) -> void:
	_swap_chest_state(coords)
