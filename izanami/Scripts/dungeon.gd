extends Node2D

var dungeon_sample = [
	["█", "I", "-", "-", "-", "-", "█", "█"],
	["█", "█", "█", "-", "T", "-", "-", "█"],
	["█", "-", "-", "-", "-", "-", "O", "█"],
	["█", "█", "-", "T", "-", "-", "█", "█"],
	["█", "█", "█", "-", "-", "█", "█", "█"]
]

var _player_pos = []
var _gear_drops = []
var _item_drops = []

@onready var map = $Map

@export var player: Player

@export var width: int = 8
@export var height: int = 5 
@export var enemy_spawn_chance: float = 0.8
@export var gear_drop_group: ResourceGroup
@export var item_drop_group: ResourceGroup
@export var exit_flag: bool = false
@export var legend: Array = ['I', 'O', '*', 'T', '█']
@export var enemy_types: Array = []

@export var player_pos: Array:
	get():
		return _player_pos
	set(coords):
		if (coords[0] < 0 or coords[0] >= width) or (coords[1] < 0 or coords[1] >= height):
			print('Out of Bounds!')
		elif coords in map.walls:
			print("There's a wall in the way")
		else:
			_player_pos = coords


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_pos = map.start
	enemy_types = [enemy_types]
	#_load_items()

	map.display_dungeon()

func _process(_delta: float) -> void:
	check_tile()

#func main(player):
	#print('-------------------------------------')
	#print("LEGEND")
	#print("%s = Player" % [legend[2]])
	#print("%s = Treasure" % [legend[3]])
	#print("%s = Wall" % [legend[4]])
	#print("%s = Exit" % [legend[1]])
	#print("Use 'w', 'a', 's', and 'd' to move")
#
	#while not exit_flag:
		##var x = input('direction? ')
		##player.move(x)
		#print('-------------------------------------')


func check_tile():
	if player_pos in map.filled_coords:
		if player_pos == map.stop:
			exit_dungeon()
		elif player_pos in map.treasure_tiles:
			collect_treasure()
		elif player_pos in map.enemy_tiles:
			initiate_battle()
		else:
			pass

func exit_dungeon():
	var x = Global.dialog_choice("Do you want to leave the Dungeon?", false)
	if x:
		exit_flag = true
	##unload all resources
	for i in _gear_drops:
		i.free()
	for i in _item_drops:
		i.free()


func _load_items():
	_gear_drops = gear_drop_group.load_all()
	_item_drops = item_drop_group.load_all()
	
	
func collect_treasure():
	var x
	var index
	var drop
	if Global.rand_chance(0.5):
		x = _gear_drops
	else:
		x = _item_drops

	index = Global.randint(0, len(x) - 1)
	drop = x[index]

	Inventory.add_item(drop)
	print("You got %s!" % [drop.name])

	map.treasure_tiles.remove(player_pos)
	map.filled_coords.remove(player_pos)

	map.display_dungeon()


func initiate_battle():
	var n = 1 + Global.rand_spread(enemy_spawn_chance, 3)
	var index
	for i in range(n):
		index = Global.randint(0, len(enemy_types) - 1)
		map.enemy_list.append(enemy_types[index])

	#battle.battle(player, enemy_list)

	map.enemy_tiles.remove(player_pos)
	map.filled_coords.remove(player_pos)

	map.display_dungeon()
