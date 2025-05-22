extends TileMapLayer

class_name LocationBackground

@onready var map: DungeonMap = get_parent().map

@export var terrain_set: int
@export var terrain_id: int

var width
var height

func draw_background():
	clear()
	width = map.width
	height = map.height
	_render_background()

func _render_background():
	var all_tiles = []
	for y in height * map.upscale_factor:
		for x in width * map.upscale_factor:
			var coord = Vector2i(x, y)
			all_tiles.append_array([
				coord * 2,
				coord * 2 + Vector2i.LEFT,
				coord * 2 + Vector2i.DOWN,
				coord * 2 + Vector2i.LEFT + Vector2i.DOWN,
			])

	set_cells_terrain_connect(all_tiles, terrain_set, terrain_id)
