extends Node

@onready var width: int = get_parent().width
@onready var height: int = get_parent().height
@onready var enemy_spawn_chance: float = get_parent().enemy_spawn_chance
@onready var legend: Array = get_parent().legend
@onready var player_pos = get_parent().player_pos

@export var treasure_spawn_chance: float = 0.2
@export var max_treasure_no: int = 5

var start = []
var stop = []
var filled_coords = []
var dungeon_map = []
var walls = []
var treasure_tiles = []
var enemy_tiles = []
var treasure_no
var enemy_no


func _ready() -> void:
	var check = false
	while not check:
		generate_dungeon_layout()
		check = verify_dungeon()
	
	_fill_gaps()
	_pad_tile(treasure_tiles)
	_pad_tile([start, stop])
	
func get_empty_tiles():
	var tiles = []
	for i in width:
		for j in height:
			tiles.append([i, j])
	
	return tiles

func _fill_gaps():
	var tiles = get_empty_tiles()
	for coord in tiles:
		if coord in walls:
			tiles.erase(coord)
	
	for tile in tiles:
		if not Global.path(start, tile, walls, width, height, []):
			walls.append(tile)

func _pad_tile(tile_set):
	var x
	var y 
	var surrounding_tiles = []
	for coord in tile_set:
		x = coord[0]
		y = coord[1]
		surrounding_tiles = [
			[x - 1, y],
			[x + 1, y],
			[x, y - 1],
			[x, y + 1],
			[x - 1, y + 1],
			[x - 1, y - 1],
			[x + 1, y + 1],
			[x + 1, y - 1],
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
	generate_walls()
	spawn_enemies_floor()

	width += 1
	height += 1

func generate_treasure_tiles():
	treasure_no = 1 + Global.rand_spread(treasure_spawn_chance, max_treasure_no)
	treasure_tiles = []
	var i = 0
	var coord
	while i < treasure_no:
		coord = Global.rand_coord(width, height)
		if coord in filled_coords:
			continue
		treasure_tiles.append(coord)
		filled_coords.append(coord)
		i += 1

func generate_walls():
	walls = []
	var cur_coord = []
	var coord = []
	var wall_chance
	var chance
	for i in range(width + 1):
		for j in range(height + 1):
			if i == 0 or j == 0 or i == width or j == height:
				chance = 0.5
			else:
				chance = 0.2
			
			cur_coord = [i, j]
			if cur_coord not in filled_coords:
				wall_chance = Global.rand_spread(chance, height/2)
				for k in range(wall_chance):
					coord = [i, j + k]
					if coord in filled_coords or coord[1] > height:
						break
					else:
						walls.append(coord)
						filled_coords.append(coord)

func spawn_enemies_floor():
	enemy_no = Global.rand_spread(enemy_spawn_chance, width * height - len(filled_coords))
	enemy_tiles = []
	var i = 0
	var coord
	while i < enemy_no:
		coord = Global.rand_coord(width, height)
		if coord in filled_coords:
			continue
		enemy_tiles.append(coord)
		filled_coords.append(coord)
		i += 1




func verify_dungeon():
	if not Global.path(start, stop, walls, width, height, []):
		return false

	for i in treasure_tiles:
		if not Global.path(start, i, walls, width, height, []):
			return false

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
	dungeon_map[start[1]][start[0]] = ' '

	# Stop
	dungeon_map[stop[1]][stop[0]] = legend[1]

	# Player_pos
	player_pos = get_parent().player_pos
	#dungeon_map[player_pos[1]][player_pos[0]] = legend[2]

	for i in treasure_tiles:
		dungeon_map[i[1]][i[0]] = legend[3]

	for i in walls:
		dungeon_map[i[1]][i[0]] = legend[4]

	for i in dungeon_map:
		print(i)
