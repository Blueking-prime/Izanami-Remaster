extends Base_Character

class_name Player

@onready var sp_bar: ProgressBar = $ProgressBar2
@onready var gear: Node = $Gear
@onready var inventory: ItemList = $Inventory

# Player stats
@export var max_sp: float:
	get():
		return (stats['AGI'] + stats['END']) * 3

@export var sp: float:
	set(value):
		sp = value
		_update_sp_bar()

@export var xp: int = 0
@export var gold: int = 0
@export var level_up_xp: int = 50 * (2 ** lvl)
@export var mag: int = 0
@export var level_stats: Array = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ally = 1
	sp = max_sp
	super()

func _update_sp_bar():
	if sp_bar:
		sp_bar.value = (sp/max_sp) * 100

func restore():
	sp += stats['END'] * 3
	if sp > max_sp:
		sp = max_sp

#func act(action: str, inst: str, target):
	#x = super().act(action, inst, target)
	#if x:
		#return x
	#if action == 'Items':
		#return use_items(inst, target)
	#return x


func update_stats():
	var current_max = [max_hp, max_sp]

	for i in stats:
		stats[i] = base_stats[i] + $Gear.stats[i]

	update_derived_stats(current_max)

func update_derived_stats(current_max: Array):
	hp = (hp/current_max[0]) * max_hp
	sp = (sp/current_max[1]) * max_sp

func level_up(value):
	xp += value
	if xp < level_up_xp:
		return

	var current_max = [max_hp, max_sp]
	var curr_stats = base_stats

	xp -= level_up_xp
	lvl += 1

	for i in level_stats:
		curr_stats[i] += 1
	
	base_stats = curr_stats

	update_derived_stats(current_max)
	level_up_xp = 50 * (2 ** lvl)


func status():
	super().status()
	if sp < 0:
		status_effect = 'EnExhaust'
	if status_effect == 'EnExhaust':
		sp -= max_sp / 4

#func move(map, direction: str):
	#x, y = map.player_pos
	#match direction:
		#case 'u':
			#map.player_pos = (x, y - 1)
		#case 'd':
			#map.player_pos = (x, y + 1)
		#case 'l':
			#map.player_pos = (x - 1, y)
		#case 'r':
			#map.player_pos = (x + 1, y)
		#case _:
			#pass
	#map.check_tile()

func die():
	super.die()
	print('And so you fall, your journey never to be completed')
## Add death screen and shit


func _on_gear_gear_change() -> void:
	update_stats()
	print(stats, hp, max_hp, sp, max_sp)
