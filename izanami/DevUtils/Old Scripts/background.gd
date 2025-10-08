extends TileMapLayer

# class_name LocationBackground

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
	else :
		var size: Vector2 = get_parent().size()
		size /= Location.TILEMAP_CELL_SIZE
		size = Vector2i(size)
		height = size.y
		width = size.x

	_render_background()

func _render_background():
	var all_tiles = []
	for y in height:
		for x in width:
			var coord = Vector2i(x, y)
			all_tiles.append(Vector2i(coord * upscale_factor))
			if upscale_factor > 1:
				all_tiles.append_array([
					Vector2i(coord * upscale_factor) + Vector2i.LEFT,
					Vector2i(coord * upscale_factor) + Vector2i.DOWN,
					Vector2i(coord * upscale_factor) + Vector2i.LEFT + Vector2i.DOWN,
				])

	set_cells_terrain_connect(all_tiles, terrain_set, terrain_id)
