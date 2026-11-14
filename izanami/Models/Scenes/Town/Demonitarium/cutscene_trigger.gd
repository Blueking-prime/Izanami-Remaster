extends Area2D

class_name CutsceneTrigger

@export var cutscenes: Dictionary [StateHandler.STATE, Resource] = {}
@export var battles: Dictionary [StateHandler.STATE, Array]

@onready var root_node: Location = get_parent().get_parent().get_parent()

var current_cutscene: JSON
var current_battle: Array

func set_state():
	if battles.has(Checks.state):
		current_battle = battles[Checks.state]

	if cutscenes.has(Checks.state) and Checks.check_cutscene_played(cutscenes[Checks.state]):
		current_cutscene = cutscenes[Checks.state]

func play_cutscene():
	set_state()
	if current_cutscene:
		await Dialogue.show_cutscene(current_cutscene)
	if current_battle:
		start_battle()

func start_battle():
	var battle: Battle = Global.battle_scene.instantiate()
	battle.rand_spawn = false

	if root_node is Town:
		battle.town = root_node
	elif root_node is Demonitarium:
		battle.demonitarium = root_node

	battle.enemy_set = current_battle
	print('battle scene spawned')
	root_node.call_deferred("add_sibling", battle)
	root_node.hide()

#func _test_states():
	#var confirm = await Global.show_confirmation_box('Do you want to change your state? ')
	#if confirm:
		#Checks.state = StateHandler.STATE.POST_KINTA
		#get_parent().set_scene_state()
