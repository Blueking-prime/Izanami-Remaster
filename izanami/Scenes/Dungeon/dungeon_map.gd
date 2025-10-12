extends Node

class_name DungeonMap

@onready var chunk_width: int:
	get(): return get_parent().width
@onready var chunk_height: int:
	get(): return get_parent().height
@onready var chunk_length: int:
	get(): return get_parent().chunk_length
@onready var enemy_spawn_chance: float:
	get(): return get_parent().enemy_spawn_chance
@onready var treasure_spawn_chance: float:
	get(): return get_parent().treasure_spawn_chance
@onready var max_enemy_spawns: int:
	get(): return get_parent().max_enemy_spawns
@onready var max_treasure_no: int:
	get(): return get_parent().max_treasure_no

@export var noise_map: FastNoiseLite

@export var legend: Array = ['I', 'O', '*', 'T', '█', 'E']
@export var path_noise_cutoff: float = 0
@export var enemy_noise_cutoff: float

var start: Vector2i
var stop: Vector2i
var width: int
var height: int

var markers: Array[Vector2i] = []
var filled_coords: Array[Vector2i] = []
var dungeon_map: Array[Array] = []
var treasure_tiles: Array[Vector2i] = []
var enemy_tiles: Array[Vector2i] = []
var walls: Array[Vector2i] = []

var treasure_no: int
var enemy_no: int

var chunks: Dictionary = {}
const UP = 1
const DOWN = 2
const LEFT = 4
const RIGHT = 8

func draw_new_map():
	width = chunk_width * chunk_length
	height = chunk_height * chunk_length

	generate_layout()
	partition_layout()

func generate_layout():
	create_noise_map()
	generate_walls()

	_pad_tile(filled_coords)

func partition_layout():
	var w_marks := _marker(width)
	var h_marks := _marker(height)

	for i in w_marks:
		for j in h_marks:
			markers.append(Vector2i(i, j))

	var chunk_no := 0
	print(markers)
	for i in markers:
		var chunk_data: Dictionary = {}
		#print('------------------------------------------------------------')
		#print(range(i.x, i.x + chunk_width))
		#print(range(i.y, i.y + chunk_height))

		chunk_data['marker'] = i
		chunk_data['walls'] = _get_tiles_in_chunk(i, walls)
		chunk_data['treasure_tiles'] = _get_tiles_in_chunk(i, treasure_tiles)
		chunk_data['enemy_tiles'] = _get_tiles_in_chunk(i, enemy_tiles)
		chunk_data['start'] = _get_tiles_in_chunk(i, [start])
		chunk_data['stop'] = _get_tiles_in_chunk(i, [stop])
		chunk_data['type'] = _get_chunk_type(i)
		chunks[chunk_no] = chunk_data
		chunk_no += 1
		#print(chunk_data)


func _get_chunk_type(marker: Vector2i) -> int:
	var type := 0

	if marker.x == 0:						type = type | LEFT
	if marker.y == 0:						type = type | UP
	if marker.x + chunk_width == width:		type = type | RIGHT
	if marker.y + chunk_height == height:	type = type | DOWN

	return type

func _get_tiles_in_chunk(marker: Vector2i, tiles: Array[Vector2i]) -> Array[Vector2i]:
		var chunk_tiles: Array[Vector2i] = []
		for j in tiles:
			if j.x in range(marker.x, marker.x + chunk_width) and j.y in range(marker.y, marker.y + chunk_height):
				chunk_tiles.append(j)
			# Skips some unnecessary iterations
			elif j.x >= marker.x + chunk_width and j.y >= marker.y + chunk_height:
				break

		return chunk_tiles

func _get_empty_tiles() -> Array[Vector2i]:
	var tiles: Array[Vector2i] = []
	for i in width:
		for j in height:
			tiles.append(Vector2i(i, j))

	return tiles

func _get_valid_point(_cutoff: float = path_noise_cutoff) -> Vector2i:
	var point = Global.rand_coord(width, height)

	var count := 0
	while true:
		if point not in filled_coords and Global.path_checker.call(start, point, _cutoff): break
		point = Global.rand_coord(width, height)
		count += 1
		if count > 1024: break

	filled_coords.append(point)

	return point

func _pad_tile(tile_set: Array[Vector2i]):
	var surrounding_tiles: Array[Vector2i] = []
	for coord in tile_set:
		surrounding_tiles = [
			coord + Vector2i.LEFT + Vector2i.DOWN,
			coord + Vector2i.LEFT,
			coord + Vector2i.LEFT + Vector2i.UP,
			coord + Vector2i.UP,
			coord + Vector2i.DOWN,
			coord + Vector2i.RIGHT + Vector2i.DOWN,
			coord + Vector2i.RIGHT,
			coord + Vector2i.RIGHT + Vector2i.UP,
		]

		for i in surrounding_tiles:
			if i in walls:
				walls.erase(i)

func _marker(length: int) -> Array:
	var marks := []
	var i := 0
	while i < length:
		marks.append(i)
		i += length / chunk_length

	return marks


func create_noise_map():
	#noise_map.seed = randi()
	Global.create_dsu_checker(noise_map, height, width, path_noise_cutoff)

	treasure_no = 1 + Global.rand_spread(treasure_spawn_chance, max_treasure_no)
	enemy_no = Global.rand_spread(enemy_spawn_chance, max_enemy_spawns)

	# Prevent fromm generating on map edge
	width -= 1
	height -= 1

	start = Global.rand_coord(width, height)
	while noise_map.get_noise_2dv(start) < path_noise_cutoff:
		start = Global.rand_coord(width, height)
	filled_coords.append(start)

	stop = _get_valid_point()
	while stop.distance_to(start) <= chunk_height or stop.distance_to(start) <= chunk_width:
		stop = _get_valid_point()

	for i in treasure_no: treasure_tiles.append(_get_valid_point())

	for i in enemy_no: enemy_tiles.append(_get_valid_point(enemy_noise_cutoff + path_noise_cutoff))

	width += 1
	height += 1

func generate_walls():
	var tiles = _get_empty_tiles()
	for i in tiles:
		##if not Global.path_checker.call(start, i):
		if noise_map.get_noise_2dv(i) < path_noise_cutoff:
			walls.append(i)

	#print(walls)
