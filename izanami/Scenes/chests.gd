extends TileMapLayer

@onready var width: int = get_parent().width
@onready var height: int = get_parent().height

@export var treasure_atlas_coords: Vector2i
@export var treasure_source_id: int

var chests: Array

@onready var map: Node = $"../Map"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#width = map.width
	#height = map.height
	chests = map.treasure_tiles
	chests = [[6, 0], [5, 6], [28, 3], [12, 4], [26, 5]]
	
	_render_treasure_chests()

func _render_treasure_chests():
	#print('chests = ', chests)
	for coord in chests:
		set_cell(
			Vector2i(2 * coord[0] + 0.5, 2 * coord[1]+1),
			treasure_source_id,
			treasure_atlas_coords
		)
