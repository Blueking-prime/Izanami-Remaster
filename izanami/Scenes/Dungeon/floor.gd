extends TileMapLayer

class_name DungeonBackground

@onready var map: DungeonMap = get_parent().map

@export var terrain_set: int
@export var terrain_id: int

var walls: Array
var width
var height

func draw_background():
	clear()
	width = map.width
	height = map.height
	_render_background_floor()

func _render_background_floor():
	var all_tiles = []
	for y in range(-2, height + 2):
		for x in range(-2, width + 2):
			all_tiles.append_array([
				Vector2i(2 * x,     2 * y),
				Vector2i(2 * x,     2 * y + 1),
				Vector2i(2 * x + 1, 2 * y),
				Vector2i(2 * x + 1, 2 * y + 1)
				])

	set_cells_terrain_connect(all_tiles, terrain_set, terrain_id)
