extends TileMapLayer

class_name LocationBackground

@export var map: DungeonMap

@export var terrain_set: int
@export var terrain_id: int

@export var width: int
@export var height: int

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

	_render_background()

func _render_background():
	var all_tiles = []
	for y in range(-1, height + 2):
		for x in range(-1, width + 2):
			all_tiles.append(Vector2i(x, y))

	set_cells_terrain_connect(all_tiles, terrain_set, terrain_id)
