extends TileMapLayer

@onready var map: Node = $"../Map"
var width: int
var height: int
var walls: Array
@export var layer: int
@export var source_id: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	width = map.width
	height = map.height
	walls = map.walls
	
	_render_inner_walls()
	_render_outer_walls()

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
	
	set_cells_terrain_connect(outer_walls, 1, 0, false)

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
	
	set_cells_terrain_connect(walls_vector_array, 1, 0, false)
