extends Node

class_name Battle

## CUSTOM PARAMETERS
@export var no_of_enemies: int
@export var enemy_group: ResourceGroup
@export var enemy_set: Array
@export var players: Party
@onready var enemies = $Enemies

## CHILD NODES
@export var choice: Control
@export var skill_panel: Control
@export var ui_panel: Control
@export var desc_box: Control
@export var dummy_control: Control
@export var player_section: Control

## WORKING VARIABLES
var actors: Array = []
var turn_order: Array = []
var enemy_array: Array = []
var player_array: Array = []
var is_battling: bool = false
var index: int = 0
var idx: int = 0
var current_player
var targetting: bool = false
var flag: StringName
var turncount = 1
var earned_exp: int

## RETURN LOCATIONS
var dungeon: Dungeon
var town: Town
var demonitarium: Node


func _ready() -> void:
	Global.description_box_parent = ui_panel
	_player_party_setup()
	player_array = players.party
	enemy_array = enemies.enemies
	actors = player_array + enemy_array
	turn_order = actors.slice(0)
	turn_order.sort_custom(func(a, b): return a.stats['AGI'] > b.stats['AGI'])
	#print(turn_order)


func _process(_delta: float) -> void:
	if targetting:
		#if is_instance_of(actors[index], Player):
		if Input.is_action_just_pressed("ui_left"):
			if index > 0:
				index -= 1
				switch_focus(index, index + 1)
			else:
				index = actors.size() - 1
				switch_focus(index, 0)
		if Input.is_action_just_pressed("ui_right"):
			if index < actors.size() - 1:
				index += 1
				switch_focus(index, index - 1)
			else:
				index = 0
				switch_focus(index, actors.size() - 1)
		if Input.is_action_just_pressed("ui_accept"):
			_action()

	if Input.is_action_just_pressed('ui_cancel') and current_player == turn_order[idx]:
		current_player.reset_menu()
		show_choice()
		_reset_focus()

	act(turn_order[idx])
	if current_player.chosen_option:
		current_player.chosen_option = false
		targetting = true
		_start_choosing()

	if not len(enemy_array):
		exit_battle("win")

## SETUP FUNCTIONS
func _player_party_setup():
	players.player_section = player_section
	players.action_menu = choice
	players.skill_panel = skill_panel
	players.battle_setup()

func exit_battle(exit_type: StringName):
	print(earned_exp, ": EARNED")
	if exit_type == "run":
		pass
	elif exit_type == "win":
		players.level_up(earned_exp)

	if dungeon:
		dungeon.reset_from_battle()
	#elif town:
		#town.reset_from_battle()
	elif demonitarium:
		demonitarium.reset_from_battle()

	players.battle_reset()
	queue_free()

## TURN FUNCTIONS
func _action():
	print(current_player, ' is acting')
	#print(current_player.stats)
	match flag:
		'Attack': use_basic_attack()
		'Skills': use_skills()
		'Items': use_items()
		'Guard': use_guard()
		'Run': use_run()

	is_battling = false
	targetting = true
	current_player.reset_menu()
	_advance_actor()

func act(actor: Base_Character):
	actor.focus()
	if not actor.alive:
		_advance_actor()
		return
	if actor.status_effect == 'Stunned':
		print('%s is stunned' % [actor.name])
		_advance_actor()
		return
	if not is_battling:
		print(actor.name)
		actor.status()
		#actor.focus()
		if is_instance_of(actor, Enemy):
			var target_player = randi_range(0, player_array.size() - 1)
			var skill_id = randi_range(0, actor.get_skills().size() - 1)
			#player_array[target_player].focus()
			actor.use_skill(skill_id, player_array[target_player])
			print('from ', actor.name)
			#player_array[target_player].unfocus()
			_advance_actor()
		else:
			is_battling = true
			current_player = actor
			show_choice()

		#actor.unfocus()

func _advance_actor():
	_reset_focus()
	idx += 1
	if idx >= actors.size():
		end_turn()

func end_turn():
	idx = 0
	turncount += 1
	for i in player_array:
		i.restore()

	for i in enemy_array:
		if not i.alive:
			earned_exp += i.exp_drop()
			enemy_array.erase(i)
			turn_order.erase(i)
			actors.erase(i)
			i.queue_free()

## POINTER FUNCTIONS
func switch_focus(x, y):
	actors[x].focus()
	actors[y].unfocus()

func show_choice():
	targetting = false
	choice.find_child("Attack").grab_focus()

func _reset_focus():
	index = 0
	for actor in actors:
		actor.unfocus()

func _start_choosing():
	_reset_focus()
	actors[index].focus()

func _release_focus():
	dummy_control.grab_focus()

## ACTION MENU SIGNAL PROCESSORS
func _on_attack_pressed() -> void:
	flag = 'Attack'
	targetting = true
	_release_focus()
	_start_choosing()

func _on_guard_pressed() -> void:
	flag = 'Guard'
	targetting = true
	_release_focus()
	_action()

func _on_run_pressed() -> void:
	flag = 'Run'
	targetting = true
	_release_focus()
	_action()

func _on_skills_pressed() -> void:
	flag = 'Skills'
	current_player.show_skill_menu()
	#_release_focus()

func _on_items_pressed() -> void:
	flag = 'Items'
	current_player.show_item_menu()
	#_release_focus()


## ACTION MENU FUNCTIONS
func use_basic_attack():
	current_player.use_skill(0, actors[index])

func use_skills():
	current_player.use_skill(current_player.active_selection, actors[index])

func use_guard():
	current_player.guard()

func use_run():
	var enemy_speed_array = []
	for i in enemy_array:
		enemy_speed_array.append(i.stats['AGI'])

	var max_enemy_speed = enemy_speed_array.max()
	if max_enemy_speed < 1:
		max_enemy_speed = 1

	if Global.rand_chance(current_player.stats['AGI'] / max_enemy_speed):
		print('You escaped')
		exit_battle("run")
	else:
		print('You failed to escape')

func use_items():
	current_player.use_item(current_player.active_selection, actors[index])

## OTHER SIGNALS
func _on_skill_panel_item_selected(_index: int) -> void:
	if desc_box.visible:
		desc_box.hide()
