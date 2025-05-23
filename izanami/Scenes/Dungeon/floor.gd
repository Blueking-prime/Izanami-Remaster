extends TileMapLayer

class_name LocationBackground

@export var map: DungeonMap

@export var terrain_set: int
@export var terrain_id: int

@export var width: int
@export var height: int
@export var upscale_factor: float

func draw_background():
	clear()
	if map:
		width = map.width
		height = map.height
		upscale_factor = map.upscale_factor
	_render_background()

func _render_background():
	var all_tiles = []
	for y in height * upscale_factor:
		for x in width * upscale_factor:
			var coord = Vector2i(x, y)
			all_tiles.append_array([
				coord * 2,
				coord * 2 + Vector2i.LEFT,
				coord * 2 + Vector2i.DOWN,
				coord * 2 + Vector2i.LEFT + Vector2i.DOWN,
			])

	set_cells_terrain_connect(all_tiles, terrain_set, terrain_id)
