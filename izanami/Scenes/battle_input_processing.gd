extends Node

class_name BattleInput

@export var choice: Control
@export var skill_panel: Control
@export var dummy_control: Control
@export var desc_box: Control


@onready var setup: BattleSetup = get_parent().setup
@onready var process_turns: BattleTurns = get_parent().process_turns
@onready var process_actions: BattleActions = get_parent().process_actions

var targetting: bool = false
var index: int = 0
var flag: StringName


func _input(event: InputEvent) -> void:
	if targetting:
		print(flag)
		#if is_instance_of(process_turns.actors[index], Player):
		if event.is_action_pressed("ui_left"):
			if index > 0:
				index -= 1
				switch_focus(index, index + 1)
			else:
				index = process_turns.actors.size() - 1
				switch_focus(index, 0)
		if event.is_action_pressed("ui_right"):
			if index < process_turns.actors.size() - 1:
				index += 1
				switch_focus(index, index - 1)
			else:
				index = 0
				switch_focus(index, process_turns.actors.size() - 1)
		if event.is_action_pressed("ui_accept"):
			process_actions.action()

	# Cancelout of action only if currently acting character is a player
	if event.is_action_pressed('ui_cancel') and \
	process_turns.current_player == process_turns.turn_order[process_turns.idx]:
		process_turns.current_player.reset_menu()
		show_choice()
		reset_target()

## POINTER FUNCTIONS
func switch_focus(x, y):
	process_turns.actors[x].target()
	process_actions.target = process_turns.actors[x]
	process_turns.actors[y].untarget()

func show_choice():
	print('path: show choice')
	targetting = false
	#choice.find_child("Attack").grab_focus()

func start_choosing():
	print('path: start choosing')
	reset_target()
	process_turns.actors[index].target()
	process_actions.target = process_turns.actors[index]


func reset_target():
	index = 0
	for actor in process_turns.actors:
		actor.untarget()

func _release_focus():
	dummy_control.grab_focus()


## ACTION MENU SIGNAL PROCESSORS
func _on_attack_pressed() -> void:
	print('path: attck pressed')

	flag = 'Attack'
	targetting = true
	_release_focus()
	start_choosing()

func _on_skills_pressed() -> void:
	flag = 'Skills'
	process_turns.current_player.show_skill_menu()

func _on_items_pressed() -> void:
	flag = 'Items'
	process_turns.current_player.show_item_menu()

func _on_guard_pressed() -> void:
	flag = 'Guard'
	targetting = true
	_release_focus()
	process_actions.action()

func _on_run_pressed() -> void:
	flag = 'Run'
	targetting = true
	_release_focus()
	process_actions.action()


## SIGNALS
func _on_skill_panel_item_activated(_index: int) -> void:
	targetting = true
	_release_focus()
	start_choosing()

func _on_skill_panel_item_selected(_index: int) -> void:
	if desc_box.visible:
		desc_box.hide()
