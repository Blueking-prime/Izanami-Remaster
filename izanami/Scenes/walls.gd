extends TileMapLayer

@onready var width: int = get_parent().get_parent().width
@onready var height: int = get_parent().get_parent().height
@onready var player: Player = get_parent().get_parent().player

@export var treasure_atlas_coords: Vector2i
@export var treasure_source_id: int
@export var entrance_atlas_coords: Vector2i
@export var entrance_source_id: int
@export var exit_atlas_coords: Vector2i
@export var exit_source_id: int
@export var wall_terrain_set: int
@export var wall_terrain: int

var walls: Array
var chests: Array
var entrance: Array
var exit: Array

@onready var map: Node = $"../../Map"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#width = map.width
	#height = map.height
	walls = map.walls
	chests = map.treasure_tiles
	entrance = map.start
	exit = map.stop
	#walls = [[0, 1], [0, 2], [0, 3], [0, 5], [0, 8], [0, 10], [0, 11], [0, 12], [0, 13], [1, 0], [1, 1], [1, 2], [1, 4], [1, 5], [1, 6], [1, 8], [1, 14], [2, 10], [2, 14], [3, 7], [3, 8], [3, 9], [3, 10], [4, 0], [4, 12], [4, 14], [5, 1], [5, 2], [5, 3], [5, 4], [5, 9], [5, 10], [5, 12], [5, 14], [6, 5], [6, 10], [6, 11], [6, 12], [6, 14], [7, 1], [7, 2], [7, 3], [7, 11], [7, 13], [7, 14], [8, 2], [8, 11], [9, 1], [9, 7], [9, 13], [10, 0], [10, 1], [10, 2], [10, 7], [10, 8], [10, 12], [10, 13], [11, 0], [11, 10], [11, 12], [11, 13], [11, 14], [12, 0], [12, 1], [12, 2], [12, 14], [13, 0], [13, 1], [13, 5], [13, 6], [13, 9], [13, 14], [14, 7], [14, 8], [14, 12], [15, 0], [15, 2], [15, 3], [15, 10], [15, 14], [16, 3], [16, 13], [16, 14], [17, 0], [17, 6], [17, 14], [18, 3], [18, 4], [18, 8], [18, 13], [18, 14], [19, 0], [19, 1], [19, 2], [19, 3], [19, 6], [19, 9], [20, 0], [20, 1], [20, 2], [20, 3], [20, 4], [20, 5], [20, 6], [20, 7], [20, 9], [21, 1], [21, 3], [21, 4], [21, 5], [21, 7], [21, 8], [21, 12], [21, 13], [22, 0], [22, 1], [22, 2], [22, 10], [22, 11], [22, 12], [22, 13], [22, 14], [23, 4], [23, 5], [23, 9], [23, 14], [24, 0], [24, 1], [24, 2], [24, 3], [24, 4], [24, 9], [24, 12], [25, 0], [25, 8], [25, 13], [26, 12], [27, 12], [27, 13], [28, 0], [28, 1], [29, 0], [29, 4], [29, 5], [29, 8], [29, 9], [29, 10], [29, 11], [29, 12], [29, 14], [0, 0], [0, 2], [0, 4], [0, 14], [8, 0], [8, 1], [9, 0], [12, 0], [16, 14], [20, 1], [20, 3], [21, 0], [21, 2]]
	#chests = [[6, 0], [5, 6], [28, 3], [12, 4], [26, 5]]
	#print('walls = ', walls)
	
	_render_treasure_chests()
	_render_inner_walls()
	_render_outer_walls()
	_render_entrance()
	_render_exit()
	_place_player()
	
func _place_player():
	player.dungeon_display()
	player.position = Vector2i(2*16*entrance[0], 2*16*entrance[1])
	print(player.position)
	print(entrance)


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

func _render_enemies():
	pass
