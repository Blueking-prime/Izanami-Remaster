extends "res://base_character.gd"

# Player stats
@export var sp: int = max_sp()
@export var gear: StringName = ''
@export var exp: int = 0
@export var gold: int = 0
@export var level_up_exp: int = 50 * (2 ** lvl)
@export var mag: int = 0
@export var level_stats: Array = []
@export var inventory: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func max_sp():
	return (stats['AGI'] + stats['END']) * 3


func restore():
	sp += stats['END'] * 3
	if sp > max_sp():
		sp = max_sp()

#func act(action: str, inst: str, target):
	#x = super().act(action, inst, target)
	#if x:
		#return x
	#if action == 'Items':
		#return use_items(inst, target)
	#return x

func update_stats():
	var current_max = [max_hp(), max_sp()]

	for i in stats:
		stats[i] = base_stats[i] + $Gear.stats[i]

	update_derived_stats(current_max)

func update_derived_stats(current_max: Array):
	hp = (hp/current_max[0]) * max_hp
	sp = (sp/current_max[1]) * max_sp

func level_up(value):
	exp += value
	if exp < level_up_exp:
		return

	var current_max = [max_hp(), max_sp()]
	var curr_stats = base_stats

	exp -= level_up_exp
	lvl += 1

	for i in level_stats:
		curr_stats[i] += 1
	
	base_stats = curr_stats

	update_derived_stats(current_max)
	level_up_exp = 50 * (2 ** lvl)


func status():
	super().status()
	if sp < 0:
		status_effect = 'EnExhaust'
	if status_effect == 'EnExhaust':
		sp -= max_sp() / 4

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
	super().die()
	print('And so you fall, your journey never to be completed')
## Add death screen and shit
