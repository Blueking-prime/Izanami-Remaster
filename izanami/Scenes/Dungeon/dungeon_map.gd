extends Node

class_name DungeonMap

@onready var width: int = get_parent().width
@onready var height: int = get_parent().height
@onready var enemy_spawn_chance: float = get_parent().enemy_spawn_chance
@onready var treasure_spawn_chance: float = get_parent().treasure_spawn_chance
@onready var max_enemy_spawns: int = get_parent().max_enemy_spawns

#@onready var player_pos = get_parent().player_pos

@export var legend: Array = ['I', 'O', '*', 'T', '█', 'E']
@export var max_treasure_no: int = 5
@export var upscale_factor: int = 2

var start: Vector2i
var stop: Vector2i
var filled_coords: Array[Vector2i] = []
var dungeon_map: Array[Array] = []
var walls: Array[Vector2i] = []
var treasure_tiles: Array[Vector2i] = []
var enemy_tiles: Array[Vector2i] = []
var treasure_no: int
var enemy_no: int

var visited: Array[Vector2i] = []

func draw_new_map():
	var check = false
	while not check:
		generate_dungeon_layout()
		check = verify_dungeon()

	_fill_gaps()

	upscale()

	_pad_tile(treasure_tiles)
	_pad_tile([start, stop])
	_pad_tile(enemy_tiles)

func upscale():
	var new_dungeon_map = []
	for j in height * upscale_factor:
		var row = []
		for i in width * upscale_factor:
			row.append('-')
		new_dungeon_map.append(row)

	var new_walls: Array[Vector2i] = []
	var new_treasure_tiles: Array[Vector2i] = []
	var new_enemy_tiles: Array[Vector2i] = []

	# [p] = [p0][pl]
	#       [p2][p3]

	for y in range(height):
		for x in range(width):
			var coord: Vector2i = Vector2i(x, y)
			if coord in walls:
				new_walls.append(coord * upscale_factor)
				new_walls.append(coord * upscale_factor + Vector2i.RIGHT)
				new_walls.append(coord * upscale_factor + Vector2i.DOWN)
				new_walls.append(coord * upscale_factor + Vector2i(1, 1))

			if coord in treasure_tiles:
				new_treasure_tiles.append(coord * upscale_factor)

			if coord in enemy_tiles:
				new_enemy_tiles.append(coord * upscale_factor)

	width *= upscale_factor
	height *= upscale_factor

	filled_coords = []
	filled_coords.append_array(new_enemy_tiles)
	filled_coords.append_array(new_treasure_tiles)
	filled_coords.append_array(new_walls)

	walls = new_walls
	treasure_tiles = new_treasure_tiles
	enemy_tiles = new_enemy_tiles

	start *= upscale_factor
	stop *= upscale_factor

func get_empty_tiles() -> Array[Vector2i]:
	var tiles: Array[Vector2i] = []
	for i in width:
		for j in height:
			tiles.append(Vector2i(i, j))

	return tiles

func _fill_gaps():
	var tiles = get_empty_tiles()
	for coord in tiles:
		if coord in walls:
			tiles.erase(coord)

	for tile in tiles:
		if tile in visited:
			continue

		var new_visits: Array[Vector2i] = []
		if not Global.path(start, tile, walls, width, height, new_visits):
			walls.append(tile)
			visited.append_array(new_visits)

func _pad_tile(tile_set: Array[Vector2i]):
	var surrounding_tiles: Array[Vector2i] = []
	for coord in tile_set:
		surrounding_tiles = [
			coord + Vector2i.LEFT,
			coord + Vector2i.RIGHT,
			coord + Vector2i.UP,
			coord + Vector2i.DOWN,

			coord + Vector2i.LEFT + Vector2i.DOWN,
			coord + Vector2i.LEFT + Vector2i.UP,
			coord + Vector2i.RIGHT + Vector2i.DOWN,
			coord + Vector2i.RIGHT + Vector2i.UP,
		]
		for i in surrounding_tiles:
			if i in walls:
				walls.erase(i)

func generate_dungeon_layout():
	width -= 1
	height -= 1
	filled_coords = []

	# Start point
	start = Global.rand_coord(width, height)
	filled_coords.append(start)

	# Exit
	stop = Global.rand_coord(width, height)
	while stop in filled_coords:
		stop = Global.rand_coord(width, height)
	filled_coords.append(stop)

	generate_treasure_tiles()
	spawn_enemy_tiles_floor()
	generate_walls()

	width += 1
	height += 1

func generate_treasure_tiles():
	treasure_no = 1 + Global.rand_spread(treasure_spawn_chance, max_treasure_no)
	treasure_tiles = []
	var coord: Vector2i
	for i in treasure_no:
		coord = Global.rand_coord(width, height)
		if coord in filled_coords:
			continue
		treasure_tiles.append(coord)
		filled_coords.append(coord)

func generate_walls():
	walls = []
	var cur_coord: Vector2i
	var coord: Vector2i
	var wall_chance: int
	var chance: float
	for i in range(width + 1):
		for j in range(height + 1):
			if i == 0 or j == 0 or i == width or j == height:
				chance = 0.5
			else:
				chance = 0.2

			cur_coord = Vector2i(i, j)
			if cur_coord not in filled_coords:
				wall_chance = Global.rand_spread(chance, height/2)
				for k in range(wall_chance):
					coord = Vector2i(i, j + k)
					if coord in filled_coords or coord.y > height:
						break
					else:
						walls.append(coord)
						filled_coords.append(coord)

func spawn_enemy_tiles_floor():
	enemy_no = Global.rand_spread(enemy_spawn_chance, max_enemy_spawns)
	enemy_tiles = []
	var coord: Vector2i
	for i in enemy_no:
		coord = Global.rand_coord(width, height)
		if coord in filled_coords:
			continue
		if coord.x < 1:
			coord.x = 1
		if coord.y < 1:
			coord.y = 1
		enemy_tiles.append(coord)
		filled_coords.append(coord)

func verify_dungeon() -> bool:
	if not Global.path(start, stop, walls, width, height, visited):
		return false

	for i in treasure_tiles:
		# Checks if node has already been visited from start
		if i in visited:
			continue

		# Else path trace from start to this point and add new path to existing paths
		var new_visits: Array[Vector2i] = []
		if not Global.path(start, i, walls, width, height, new_visits):
			return false
		visited.append_array(new_visits)

	return true

func display_dungeon():
	dungeon_map = []
	var row
	for i in height:
		row = []
		for j in width:
			row.append('_')
		dungeon_map.append(row)

	# Start
	dungeon_map[start.y][start.x] = '*'

	# Stop
	dungeon_map[stop.y][stop.x] = legend[1]

	# Player_pos
	#player_pos = get_parent().player_pos
	#dungeon_map[player_pos.y][player_pos.x] = legend[2]

	for i in treasure_tiles:
		dungeon_map[i.y][i.x] = legend[3]

	for i in walls:
		dungeon_map[i.y][i.x] = legend[4]

	for i in enemy_tiles:
		dungeon_map[i.y][i.x] = legend[5]

	for i in dungeon_map:
		print(i)

func save() -> DungeonMapSaveData:
	var save_data: DungeonMapSaveData = DungeonMapSaveData.new()

	save_data.dungeon_map = dungeon_map
	save_data.enemy_no = enemy_no
	save_data.enemy_tiles = enemy_tiles
	save_data.filled_coords = filled_coords
	save_data.start = start
	save_data.stop = stop
	save_data.treasure_no = treasure_no
	save_data.treasure_tiles = treasure_tiles
	save_data.walls = walls

	return save_data

func load_data(save_data: DungeonMapSaveData):
	dungeon_map = save_data.dungeon_map
	enemy_no = save_data.enemy_no
	enemy_tiles = save_data.enemy_tiles
	filled_coords = save_data.filled_coords
	start = save_data.start
	stop = save_data.stop
	treasure_no = save_data.treasure_no
	treasure_tiles = save_data.treasure_tiles
	walls = save_data.walls
