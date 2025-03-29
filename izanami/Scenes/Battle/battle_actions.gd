extends Node

class_name BattleActions

@onready var process_input: BattleInput = get_parent().process_input
@onready var process_turns: BattleTurns = get_parent().process_turns
@onready var setup: BattleSetup = get_parent().setup

var target
var player: Player

## TURN FUNCTIONS
func action():
	print('path: action')
	player = process_turns.current_player
	print(player.character_name, ' is acting')
	print(process_input.flag)
	#print(player.stats)
	match process_input.flag:
		'Attack': await use_basic_attack()
		'Skills': await use_skills()
		'Items': await use_items()
		'Guard': await use_guard()
		'Run': await use_run()

	process_input.flag = ''

	process_input.targetting = false
	process_input.aoe_targetting = false
	player.reset_menu()
	process_input.desc_box.show()
	process_turns.advance_actor()



## ACTION MENU FUNCTIONS
func use_basic_attack():
	player.use_skill(0, target)

func use_skills():
	player.use_skill(player.active_selection, target)

func use_items():
	player.use_item(player.active_selection, target)

func use_guard():
	player.guard()

func use_run():
	if Global.rand_chance(player.stats['AGI'] / _calc_enemy_speed()):
		print('You escaped')
		setup.exit_battle("run", 0)
	else:
		print('You failed to escape')

## AUX FUNCTIONS
func _calc_enemy_speed() -> int:
	var enemy_speed_array = []
	for i in process_turns.enemy_array:
		enemy_speed_array.append(i.stats['AGI'])

	var max_enemy_speed = enemy_speed_array.max()
	if max_enemy_speed < 1:
		max_enemy_speed = 1

	return max_enemy_speed
