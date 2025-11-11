extends TileMapLayer

class_name LocationBackground

@export var map: DungeonMap
@export var chunk_handler: WallChunkLoader

@export var terrain_set: int
@export var terrain_id: int

@export var width: int
@export var height: int

var chunks: Dictionary = {}
var all_tiles: Array[Vector2i] = []

func draw_background():
	clear()
	if map:
		width = map.width
		height = map.height
	else :
		var size: Vector2 = get_parent().size()
		size /= Location.TILEMAP_CELL_SIZE
		size = Vector2i(size)
		height = size.y
		width = size.x

	physics_quadrant_size = maxi(height, width)
	_create_set_of_tiles()
	_render_background(all_tiles)
	if map:
		sectionalise_background()

func _create_set_of_tiles():
	all_tiles = []
	for y in range(-1, height + 2):
		for x in range(-1, width + 2):
			all_tiles.append(Vector2i(x, y))

func _render_background(tiles: Array):
	clear()
	set_cells_terrain_connect(tiles, terrain_set, terrain_id)

func sectionalise_background():
	var chunk_no := 0
	for i in map.markers:
		chunks[chunk_no] = map.get_tiles_in_chunk(i, all_tiles)
		chunk_no += 1

func show_loaded_background():
	var current_tiles := []
	for i in chunk_handler.chunk_tiles:
		if i is DungeonChunk: current_tiles.append_array(chunks[i.chunk_no])

	_render_background(current_tiles)
