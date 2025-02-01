extends Node

class_name BattleTurns

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
	if actor.status_effect == 'Stunned':
		print('%s is stunned' % [actor.name])
		advance_actor()
		return

	print(actor.name)
	actor.status()
	#actor.focus()
	if is_instance_of(actor, Enemy):
		enemy_attack_script_placeholder()
	else:
		current_player = actor
		process_input.show_choice()

		#actor.unfocus()

func advance_actor():
	process_input.reset_target()
	actor.unset_acting()

	idx += 1
	if idx >= actors.size():
		end_turn()

	actor = turn_order[idx]
	act()

func end_turn():
	idx = 0
	turncount += 1
	for i in player_array:
		i.restore()

	for i in enemy_array:
		if not i.alive:
			get_parent().earned_exp += i.exp_drop()
			enemy_array.erase(i)
			turn_order.erase(i)
			actors.erase(i)
			i.queue_free()

	if not len(enemy_array):
		setup.exit_battle("win", get_parent().earned_exp)

func enemy_attack_script_placeholder():
	var target_player = randi_range(0, player_array.size() - 1)
	var skill_id = randi_range(0, actor.get_skills().size() - 1)
	#player_array[target_player].focus()
	actor.use_skill(skill_id, player_array[target_player])
	print('from ', actor.name)
	#player_array[target_player].unfocus()
	advance_actor()

#
#func _on_battle_ready() -> void:
	#act()
