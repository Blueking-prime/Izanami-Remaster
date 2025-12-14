extends Node

class_name BattleSetup

@export var player_section: Control
@export var choice: Control
@export var skill_panel: Control
@export var desc_box_parent: Control
@export var action_log: Label

@onready var process_turns: BattleTurns = get_parent().process_turns

## RETURN LOCATIONS
@onready var dungeon: Dungeon = get_parent().dungeon
@onready var town: Town = get_parent().town
@onready var demonitarium: Demonitarium = get_parent().demonitarium


func actor_setup():
	Global.description_box_parent = desc_box_parent
	Global.action_log = action_log

	get_parent().enemies.load_enemies()
	_player_party_setup()

	# Create actor arrays
	process_turns.player_array = Global.players.party
	process_turns.enemy_array = get_parent().enemies.enemies
	process_turns.actors = process_turns.player_array + process_turns.enemy_array

	# Duplicate array and set turn order according to speed
	process_turns.turn_order = process_turns.actors.slice(0)
	process_turns.turn_order.sort_custom(func(a, b): return a.stats['AGI'] > b.stats['AGI'])

	get_tree().current_scene = get_parent()
	Audio.call_deferred('set_background_music')


func _player_party_setup():
	Global.players.player_section = player_section
	Global.players.action_menu = choice
	Global.players.skill_panel = skill_panel
	Global.players.battle_setup()


func exit_battle(exit_type: StringName):
	if exit_type == "run":
		get_parent().earned_exp /= 2
		get_parent().earned_gold = 0
	#elif exit_type == "win":
		#get_parent().earned_exp
		#get_parent().earned_gold

	Global.players.level_up(get_parent().earned_exp)
	Global.players.gold += get_parent().earned_gold


	Global.print_to_log(str(get_parent().earned_exp) + "XP EARNED")
	Global.print_to_log(str(get_parent().earned_gold) + "G EARNED")
	# Prepare return scene
	if dungeon:
		dungeon.reset_from_battle()
	#elif town:
		#town.reset_from_battle()
	elif demonitarium:
		demonitarium.reset_from_battle()

	Global.players.battle_reset()
	get_parent().queue_free()
