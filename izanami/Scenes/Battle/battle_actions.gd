extends Node

class_name BattleActions

@onready var process_input: BattleInput = get_parent().process_input
@onready var process_turns: BattleTurns = get_parent().process_turns
@onready var setup: BattleSetup = get_parent().setup

var target

## TURN FUNCTIONS
func action():
	Global.print_to_log(process_turns.current_player.character_name + ' is acting')
	match process_input.flag:
		'Attack': await use_basic_attack()
		'Skills': await use_skills()
		'Items': await use_items()
		'Guard': await use_guard()
		'Run': await use_run()

	process_input.flag = ''

	process_input.targetting = false
	process_input.aoe_targetting = false
	process_turns.current_player.reset_menu()
	process_input.desc_box.show()
	process_turns.advance_actor()



## ACTION MENU FUNCTIONS
func use_basic_attack():
	process_turns.current_player.use_skill(0, target)
	await get_tree().create_timer(1).timeout

func use_skills():
	process_turns.current_player.use_skill(process_turns.current_player.active_selection, target)
	await get_tree().create_timer(1).timeout

func use_items():
	process_turns.current_player.use_item(process_turns.current_player.active_selection, target)
	await get_tree().create_timer(1).timeout

func use_guard():
	process_turns.current_player.guard()
	await get_tree().create_timer(1).timeout

func use_run():
	if Global.rand_chance(process_turns.current_player.stats['AGI'] / _calc_enemy_speed()):
		Global.print_to_log('You escaped')
		setup.exit_battle("run")
	else:
		Global.print_to_log('You failed to escape')

## AUX FUNCTIONS
func _calc_enemy_speed() -> int:
	var enemy_speed_array = []
	for i in process_turns.enemy_array:
		enemy_speed_array.append(i.stats['AGI'])

	var max_enemy_speed = enemy_speed_array.max()
	if max_enemy_speed < 1:
		max_enemy_speed = 1

	return max_enemy_speed
