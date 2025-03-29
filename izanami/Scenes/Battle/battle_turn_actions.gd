extends Node

class_name BattleTurns

@export var turncount_label: Label

@onready var process_input: BattleInput = get_parent().process_input
@onready var setup: BattleSetup = get_parent().setup

## WORKING VARIABLES
var actors: Array = []
var turn_order: Array = []
var enemy_array: Array = []
var player_array: Array = []

var turncount: int = 1
var current_player: Player
var actor: Base_Character
var idx: int = 0


func act():
	if not actor:
		actor = turn_order[0]

	actor.set_acting()

	if not actor.alive:
		advance_actor()
		return

	actor.statuses.status()
	if actor.statuses.stunned:
		print('%s is stunned' % [actor.character_name])
		advance_actor()
		return

	print(actor.character_name)
	#actor.focus()
	if actor is Enemy:
		await actor.battle_ai(player_array, enemy_array)
		advance_actor()
	else:
		current_player = actor
		process_input.show_choice()

		#actor.unfocus()

func advance_actor():
	process_input.reset_target()
	actor.unset_acting()

	#Check if enemies were one-shot basically
	if check_if_enemies_all_dead():
		kill_enemies()
		end_battle()

	idx += 1
	if idx >= actors.size():
		end_turn()

	actor = turn_order[idx]
	act()

func kill_enemies():
	for i in enemy_array:
		print(i.character_name, i.alive)
		if not i.alive:
			print(i, ' should die')
			get_parent().earned_exp += i.exp_drop()
			get_parent().earned_gold += i.gold_drop()
			enemy_array.erase(i)
			turn_order.erase(i)
			actors.erase(i)
			i.queue_free()

func check_if_enemies_all_dead():
	for i in enemy_array:
		if i.alive:
			return false
	return true


func end_turn():
	idx = 0
	turncount += 1

	kill_enemies()

	if not len(enemy_array):
		end_battle()

	turncount_label.text = str(turncount)

func end_battle():
	setup.exit_battle("win", get_parent().earned_exp)

#func enemy_attack_script_placeholder():
	#var target_player = randi_range(0, player_array.size() - 1)
	#var skill_id = randi_range(0, actor.get_skills().size() - 1)
	##player_array[target_player].focus()
	#if actor.get_skills()[skill_id].aoe:
		#actor.use_skill(skill_id, player_array)
	#else:
		#actor.use_skill(skill_id, player_array[target_player])
	#print('from ', actor.name)
	##player_array[target_player].unfocus()
	#advance_actor()

#
#func _on_battle_ready() -> void:
	#act()
