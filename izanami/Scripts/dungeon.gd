extends Node2D

var dungeon_sample = [
	["█", "I", "-", "-", "-", "-", "█", "█"],
	["█", "█", "█", "-", "T", "-", "-", "█"],
	["█", "-", "-", "-", "-", "-", "O", "█"],
	["█", "█", "-", "T", "-", "-", "█", "█"],
	["█", "█", "█", "-", "-", "█", "█", "█"]
]

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
		return [player.position.x / 16, player.position.y / 16]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_types = [enemy_types]
	#_load_items()
	Shape2D

	map.display_dungeon()


## EXIT LOGIC
func exit_dungeon():
	var x = Global.dialog_choice("Do you want to leave the Dungeon?", false)
	if x:
		exit_flag = true
	##unload all resources
	for i in _gear_drops:
		i.free()
	for i in _item_drops:
		i.free()




## TREASURE LOGIC
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



## BATTLE LOGIC
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
