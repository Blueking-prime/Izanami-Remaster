extends TileMapLayer

class_name DungeonWallsLayer


@onready var root_node: Dungeon:
	get():
		return get_parent().get_parent()

@onready var map: DungeonMap:
	get():
		return root_node.map


@export var wall_terrain_set: int
@export var wall_terrain: int
@export var layer: int

var walls_2: Array
var width: int
var height: int
var upscale_factor: int

func render_objects():
	if not layer in map.walls.keys(): return
	walls_2 = map.walls[layer]
	#print(walls_2)
	height = map.height
	width = map.width
	upscale_factor = map.upscale_factor
	#print('walls = ', walls)

	_render_walls()


func _render_walls():
	var walls_vector_array: Array[Vector2i] = []
	for coord in walls_2:
		walls_vector_array.append_array([
				coord * upscale_factor,
				coord * upscale_factor + Vector2i.LEFT,
				coord * upscale_factor + Vector2i.DOWN,
				coord * upscale_factor + Vector2i.LEFT + Vector2i.DOWN,
			])

	set_cells_terrain_connect(walls_vector_array, wall_terrain_set, wall_terrain, false)



func save() -> TileMapPattern:
	return get_pattern(get_used_cells())

func load_data(data: DungeonSaveData):
	load_tiles(data.tile_data)

	await get_tree().create_timer(0.1).timeout

func load_tiles(pattern: TileMapPattern):
	set_pattern(Vector2i(), pattern)
