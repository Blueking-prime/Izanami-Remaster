extends Node

class_name BattleSetup

@export var player_section: Control
@export var choice: Control
@export var skill_panel: Control
@export var desc_box_parent: Control
@export var action_log: Label

@onready var players: Party = get_parent().players
@onready var enemies = get_parent().enemies

@onready var process_turns: BattleTurns = get_parent().process_turns

## RETURN LOCATIONS
@onready var dungeon: Dungeon = get_parent().dungeon
@onready var town: Town = get_parent().town
@onready var demonitarium: Node = get_parent().demonitarium


func actor_setup():
	Global.description_box_parent = desc_box_parent
	Global.action_log = action_log

	enemies.load_enemies()
	_player_party_setup()

	# Create actor arrays
	process_turns.player_array = players.party
	process_turns.enemy_array = enemies.enemies
	process_turns.actors = process_turns.player_array + process_turns.enemy_array

	# Duplicate array and set turn order according to speed
	process_turns.turn_order = process_turns.actors.slice(0)
	process_turns.turn_order.sort_custom(func(a, b): return a.stats['AGI'] > b.stats['AGI'])


func _player_party_setup():
	players.player_section = player_section
	players.action_menu = choice
	players.skill_panel = skill_panel
	players.battle_setup()


func exit_battle(exit_type: StringName, earned_exp: int):
	print(earned_exp, ": EARNED")
	if exit_type == "run":
		pass
	elif exit_type == "win":
		players.level_up(earned_exp)

	# Prepare return scene
	if dungeon:
		dungeon.reset_from_battle()
	#elif town:
		#town.reset_from_battle()
	elif demonitarium:
		demonitarium.reset_from_battle()

	players.battle_reset()
	get_parent().queue_free()
