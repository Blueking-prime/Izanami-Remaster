extends Node

# class_name DungeonMap

@onready var width: int = get_parent().width
@onready var height: int = get_parent().height
@onready var max_chunks: int = get_parent().max_chunks
@onready var enemy_spawn_chance: float = get_parent().enemy_spawn_chance
@onready var treasure_spawn_chance: float = get_parent().treasure_spawn_chance
@onready var max_enemy_spawns: int = get_parent().max_enemy_spawns

#@onready var player_pos = get_parent().player_pos

@export var noise_map: FastNoiseLite
@export var legend: Array = ['I', 'O', '*', 'T', '█', 'E']
@export var max_treasure_no: int = 5

@export var upscale_factor: int = 2
@export var path_noise_cutoff: float = 0
@export var wall_layer_multiplier: float = 2
@export var wall_layer_steps_default: float = 0.2
@export var enemy_noise_cutoff: float
@export var max_layers: int = 1

var wall_layer_steps: float:
	get():
		if path_noise_cutoff:
			return abs(path_noise_cutoff * wall_layer_multiplier)
		else:
			return wall_layer_steps_default

var start: Vector2i
var stop: Vector2i
var filled_coords: Array[Vector2i] = []
var dungeon_map: Array[Array] = []
var treasure_tiles: Array[Vector2i] = []
var enemy_tiles: Array[Vector2i] = []
var treasure_no: int
var enemy_no: int
var walls: Dictionary = {
	0: []
}
var visited: Array[Vector2i] = []

func draw_new_map():
	#var check = false
	#while not check:
		#generate_dungeon_layout()
		#check = verify_dungeon()
	#_fill_gaps()

	gererate_dungeon_layout_noise()
	_fill_gaps_noise()

	if upscale_factor > 1:
		upscale()

	_pad_tile(treasure_tiles)
	_pad_tile([start, stop])
	_pad_tile(enemy_tiles)

# Generated map modifiers
func upscale():
	var new_dungeon_map = []
	for j in height * upscale_factor:
		var row = []
		for i in width * upscale_factor:
			row.append('-')
		new_dungeon_map.append(row)

	var new_walls: Dictionary
	var new_treasure_tiles: Array[Vector2i] = []
	var new_enemy_tiles: Array[Vector2i] = []

	# [p] = [p0][pl]
	#       [p2][p3]

	wall_layer_steps *= upscale_factor

	for y in range(height):
		for x in range(width):
			var coord: Vector2i = Vector2i(x, y)
			if coord in walls[0]:
				_upscale_wall(coord, new_walls)

			if coord in treasure_tiles:
				new_treasure_tiles.append(coord * upscale_factor)

			if coord in enemy_tiles:
				new_enemy_tiles.append(coord * upscale_factor)

	width *= upscale_factor
	height *= upscale_factor

	filled_coords = []
	filled_coords.append_array(new_enemy_tiles)
	filled_coords.append_array(new_treasure_tiles)

	walls = new_walls
	treasure_tiles = new_treasure_tiles
	enemy_tiles = new_enemy_tiles

	start *= upscale_factor
	stop *= upscale_factor

func _upscale_wall(coord: Vector2i, store_array: Dictionary):
	var coord_1 = coord * upscale_factor
	_generate_walls_layered(store_array, coord_1, noise_map.get_noise_2dv(coord_1 / upscale_factor))
	var coord_2 = coord * upscale_factor + Vector2i.RIGHT
	_generate_walls_layered(store_array, coord_2, noise_map.get_noise_2dv(coord_2 / upscale_factor))
	var coord_3 = coord * upscale_factor + Vector2i.DOWN
	_generate_walls_layered(store_array, coord_3, noise_map.get_noise_2dv(coord_3 / upscale_factor))
	var coord_4 = coord * upscale_factor + Vector2i(1, 1)
	_generate_walls_layered(store_array, coord_4, noise_map.get_noise_2dv(coord_4 / upscale_factor))
	#store_array.append(coord * upscale_factor)
	#store_array.append(coord * upscale_factor + Vector2i.RIGHT)
	#store_array.append(coord * upscale_factor + Vector2i.DOWN)
	#store_array.append(coord * upscale_factor + Vector2i(1, 1))


func get_empty_tiles() -> Array[Vector2i]:
	var tiles: Array[Vector2i] = []
	for i in width:
		for j in height:
			tiles.append(Vector2i(i, j))

	for i in tiles:
		if i.x >= width or i.y >= height:
			print('Error tile: ',i)
	#print('Total tiles',tiles.size())
	return tiles

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
			for j in walls.keys():
				if i in walls[j]:
					walls[j].erase(i)

# Map geeration logic using noise
func get_valid_point(_cutoff: float = path_noise_cutoff) -> Vector2i:
	var point = Global.rand_coord(width, height)

	var count = 0
	while true:
		#print('Point: ', point, ' ', filled_coords, ' ', Global.path_checker.call(start, point, _cutoff), ' ', noise_map.get_noise_2dv(point))
		if point not in filled_coords and Global.path_checker.call(start, point, _cutoff):
			break
		point = Global.rand_coord(width, height)
		count += 1
		if count >= 1024:
			print('Stack 1024')
			#get_tree().call_deferred("quit")

	filled_coords.append(point)

	return point

func gererate_dungeon_layout_noise():
	#noise_map.seed = randi()
	noise_map.frequency *= upscale_factor
	Global.create_dsu_checker(noise_map, height, width, path_noise_cutoff)

	treasure_no = 1 + Global.rand_spread(treasure_spawn_chance, max_treasure_no)
	enemy_no = Global.rand_spread(enemy_spawn_chance, max_enemy_spawns)

	# Prevent fromm generating on map edge
	width -= 1
	height -= 1

	start = Global.rand_coord(width, height)
	while noise_map.get_noise_2dv(start) < 0:
		start = Global.rand_coord(width, height)
	#print('Start found')

	filled_coords.append(start)


	stop = get_valid_point()
	#print('Stop found')

	for i in treasure_no: treasure_tiles.append(get_valid_point())
	#print('Treasures found')

	for i in enemy_no: enemy_tiles.append(get_valid_point(enemy_noise_cutoff + path_noise_cutoff))
	#print('Enemies found')

	width += 1
	height += 1

func _generate_walls_layered(store_array: Dictionary, coord: Vector2i, noise_value: float):
	var layer = 0
	var count = 0
	while layer >= -1 and layer >= noise_value and count < max_layers:
		store_array.get_or_add(count, []).append(coord)
		layer -= wall_layer_steps
		count += 1

func _fill_gaps_noise():
	var tiles = get_empty_tiles()

	# Replace inaccesible areas with walls
	for i in tiles:
		var data = noise_map.get_noise_2dv(i)
		##if not Global.path_checker.call(start, i):
		if data < path_noise_cutoff:
			_generate_walls_layered(walls, i, data)

		#if noise_map.get_noise_2dv(i):
		##if not Global.path_checker.call(start, i):
			#walls.append(i)
			##print(noise_map.get_noise_2dv(i))
			#if abs(noise_map.get_noise_2dv(i)) >= layer_2_threshold:
				#walls_2.append(i)

#region Old map generation logic
#func _fill_gaps():
	#var tiles = get_empty_tiles()
	#for coord in tiles:
		#if coord in walls:
			#tiles.erase(coord)
#
	#for tile in tiles:
		#if tile in visited:
			#continue
#
		#var new_visits: Array[Vector2i] = []
		#if not Global.path(start, tile, walls, width, height, new_visits):
			#walls.append(tile)
			#visited.append_array(new_visits)
#
#func generate_dungeon_layout():
	#width -= 1
	#height -= 1
	#filled_coords = []
#
	## Start point
	#start = Global.rand_coord(width, height)
	#filled_coords.append(start)
#
	## Exit
	#stop = Global.rand_coord(width, height)
	#while stop in filled_coords:
		#stop = Global.rand_coord(width, height)
	#filled_coords.append(stop)
#
	#generate_treasure_tiles()
	#spawn_enemy_tiles_floor()
	#generate_walls()
#
	#width += 1
	#height += 1
#
#func generate_treasure_tiles():
	#treasure_no = 1 + Global.rand_spread(treasure_spawn_chance, max_treasure_no)
	#treasure_tiles = []
	#var coord: Vector2i
	#for i in treasure_no:
		#coord = Global.rand_coord(width, height)
		#if coord in filled_coords:
			#continue
		#treasure_tiles.append(coord)
		#filled_coords.append(coord)
#
#func generate_walls():
	#walls = []
	#var cur_coord: Vector2i
	#var coord: Vector2i
	#var wall_chance: int
	#var chance: float
	#for i in range(width):
		#for j in range(height):
			#if i == 0 or j == 0 or i == width or j == height:
				#chance = 0.5
			#else:
				#chance = 0.2
#
			#cur_coord = Vector2i(i, j)
			#if cur_coord not in filled_coords:
				#wall_chance = Global.rand_spread(chance, height/2)
				#for k in range(wall_chance):
					#coord = Vector2i(i, j + k)
					#if coord in filled_coords or coord.y > height:
						#break
					#else:
						#walls.append(coord)
						#filled_coords.append(coord)
#
#func spawn_enemy_tiles_floor():
	#enemy_no = Global.rand_spread(enemy_spawn_chance, max_enemy_spawns)
	#enemy_tiles = []
	#var coord: Vector2i
	#for i in enemy_no:
		#coord = Global.rand_coord(width, height)
		#if coord in filled_coords:
			#continue
		#if coord.x < 1:
			#coord.x = 1
		#if coord.y < 1:
			#coord.y = 1
		#enemy_tiles.append(coord)
		#filled_coords.append(coord)
#
#func verify_dungeon() -> bool:
	#if not Global.path(start, stop, walls, width, height, visited):
		#return false
#
	#for i in treasure_tiles:
		## Checks if node has already been visited from start
		#if i in visited:
			#continue
#
		## Else path trace from start to this point and add new path to existing paths
		#var new_visits: Array[Vector2i] = []
		#if not Global.path(start, i, walls, width, height, new_visits):
			#return false
		#visited.append_array(new_visits)
#
	#return true
#endregion

# Displaymap in terminal
#func display_dungeon():
	#dungeon_map = []
	#var row
	#for i in height:
		#row = []
		#for j in width:
			#row.append('_')
		#dungeon_map.append(row)
#
	#print('height: ', dungeon_map.size())
	#print('width: ', dungeon_map[0].size())
	## Start
	#dungeon_map[start.y][start.x] = '*'
#
	## Stop
	#dungeon_map[stop.y][stop.x] = legend[1]
#
	## Player_pos
	##player_pos = get_parent().player_pos
	##dungeon_map[player_pos.y][player_pos.x] = legend[2]
#
	#for i in treasure_tiles:
		##print(i)
		#dungeon_map[i.y][i.x] = legend[3]
#
	##for i in walls:
		##if i.x >= 100 or i.y >= 80:
			##print('Error tile: ',i)
#
#
	#for i in walls:
		##print(i)
		#dungeon_map[i.y][i.x] = legend[4]
#
	#for i in enemy_tiles:
		##print(i)
		#dungeon_map[i.y][i.x] = legend[5]
#
	#for i in dungeon_map:
		#print(i)


func generate_chunks(): pass

# Map saving and loading
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
	#save_data.walls = walls

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
	#walls = save_data.walls
