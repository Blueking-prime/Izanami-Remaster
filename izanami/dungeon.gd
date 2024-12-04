extends Node2D

var dungeon_sample = [
	["█", "I", "-", "-", "-", "-", "█", "█"],
	["█", "█", "█", "-", "T", "-", "-", "█"],
	["█", "-", "-", "-", "-", "-", "O", "█"],
	["█", "█", "-", "T", "-", "-", "█", "█"],
	["█", "█", "█", "-", "-", "█", "█", "█"]
]

var _player_pos = []

@export var width: int = 8
@export var height: int = 5 
@export var spawn_chance: float = 0.8
@export var gear_drops: ResourceGroup
@export var item_drops: ResourceGroup
@export var exit_flag: bool = false
@export var legend: Array = ['I', 'O', '*', 'T', '█']
@export var enemy_types: Array = []

var start = []
var stop = []
var filled_coords = []
var enemy_list = []
var dungeon_map = []
var walls = []
var treasure_no
var treasure_tiles = []
var enemy_no
var enemy_tiles

@export var player_pos: Array:
	get():
		return _player_pos
	set(coords):
		if (coords[0] < 0 or coords[0] >= width) or (coords[1] < 0 or coords[1] >= height):
			print('Out of Bounds!')
		elif coords in walls:
			print("There's a wall in the way")
		else:
			_player_pos = coords
			display_dungeon()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var check = false
	while not check:
		generate_dungeon_layout()
		check = verify_dungeon()

	player_pos = start
	enemy_types = [enemy_types]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func main(player):
	print('-------------------------------------')
	print("LEGEND")
	print("%s = Player" % [legend[2]])
	print("%s = Treasure" % [legend[3]])
	print("%s = Wall" % [legend[4]])
	print("%s = Exit" % [legend[1]])
	print("Use 'w', 'a', 's', and 'd' to move")

	while not exit_flag:
		#var x = input('direction? ')
		#player.move(x)
		print('-------------------------------------')

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
	treasure_no = 1 + Global.rand_spread(0.2, 5)
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
	for i in range(width + 1):
		for j in range(height + 1):
			if i == 0 or j == 0 or i == width or j == height:
				var chance = 0.7
			else:
				var chance = 0.3

			#if i, j not in filled_coords:
				#wall_chance = Global.rand_spread(chance, height/2)
				#for k in range(wall_chance):
					#coord = i, j + k
					#if coord in filled_coords or coord[1] > height:
						#break
					#else:
						#walls.append(coord)
						#filled_coords.append(coord)

func spawn_enemies_floor():
	enemy_no = Global.rand_spread(spawn_chance, width * height - len(filled_coords))
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


func check_tile(player):
	if player_pos in filled_coords:
		if player_pos == stop:
			exit_dungeon()
		elif player_pos in treasure_tiles:
			collect_treasure(player)
		elif player_pos in enemy_tiles:
			initiate_battle(player)
		else:
			pass

func exit_dungeon():
	var x = Global.dialog_choice("Do you want to leave the Dungeon?", false)
	if x:
		exit_flag = true

func collect_treasure(player):
	var x
	var index
	var drop
	if Global.rand_chance(0.5):
		x = gear_drops
		index = Global.randint(0, len(x) - 1)
		#drop = Base_Gear(x[index])
	else:
		x = item_drops
		index = Global.randint(0, len(x) - 1)
		#drop = Base_Item(x[index])

	player.inventory.append(drop)
	print("You got {drop.name}!")

	treasure_tiles.remove(player_pos)
	filled_coords.remove(player_pos)

	display_dungeon()


func initiate_battle(player):
	var n = 1 + Global.rand_spread(spawn_chance, 3)
	var index
	for i in range(n):
		index = Global.randint(0, len(enemy_types) - 1)
		enemy_list.append(enemy_types[index])

	#battle.battle(player, enemy_list)

	enemy_tiles.remove(player_pos)
	filled_coords.remove(player_pos)

	display_dungeon()


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

	# Start
	dungeon_map[start[1]][start[0]] = ' '

	# Stop
	dungeon_map[stop[1]][stop[0]] = legend[1]

	# Player_pos
	dungeon_map[player_pos[1]][player_pos[0]] = legend[2]

	for i in treasure_tiles:
		dungeon_map[i[1]][i[0]] = legend[3]

	for i in walls:
		dungeon_map[i[1]][i[0]] = legend[4]

	for i in dungeon_map:
		print(i)
