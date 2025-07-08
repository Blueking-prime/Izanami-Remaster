extends Node

class_name BattleInput

@export var choice: Control
@export var skill_panel: Options
@export var dummy_control: Control
@export var desc_box: Control
@export var dummy_option: Button


@onready var setup: BattleSetup = get_parent().setup
@onready var process_turns: BattleTurns = get_parent().process_turns
@onready var process_actions: BattleActions = get_parent().process_actions

var targetting: bool = false
var index: int = 0
var flag: StringName
var aoe_targetting: bool = false
var target_group: Array = []
var offense: bool = true

## TARGETTING
func _left_press():
	if aoe_targetting:
		switch_focus_aoe()
	else:
		if index > 0:
			index -= 1
			switch_focus(index, index + 1)
		else:
			index = process_turns.actors.size() - 1
			switch_focus(index, 0)

func _right_press():
	if aoe_targetting:
		switch_focus_aoe()
	else:
		if index < process_turns.actors.size() - 1:
			index += 1
			switch_focus(index, index - 1)
		else:
			index = 0
			switch_focus(index, process_turns.actors.size() - 1)

func _up_or_down_press():
	if aoe_targetting:
		switch_focus_aoe()
	else:
		print(index)
		if index > process_turns.player_array.size() - 1:
			switch_focus(0, index)
			index = 0
		else:
			switch_focus(process_turns.player_array.size(), index)
			index = process_turns.player_array.size()

func _set_target_by_index(event: InputEvent):
	if not aoe_targetting:
		var key = int(event.as_text().trim_prefix('Kp ')) - 1
		print(key)
		if key < process_turns.actors.size():
			switch_focus(key, index)
			index = key


func _cancel_targetting():
	process_turns.current_player.reset_menu()
	skill_panel.hide()
	show_choice()
	reset_target()

## TARGET FOCUS FUNCTIONS
func switch_focus(x, y):
	process_turns.actors[y].untarget()
	process_actions.target = process_turns.actors[x]
	process_turns.actors[x].target()

func switch_focus_aoe():
	if target_group == process_turns.enemy_array:
		target_group = process_turns.player_array
	else:
		target_group = process_turns.enemy_array

	reset_target()
	for i in target_group:
		i.target()

	process_actions.target = target_group

func start_choosing():
	targetting = true
	reset_target()
	if offense:
		index = process_turns.player_array.size()

	process_turns.actors[index].target()
	process_actions.target = process_turns.actors[index]

func start_choosing_aoe():
	targetting = true
	aoe_targetting = true
	reset_target()

	if offense:
		target_group = process_turns.enemy_array
	else :
		target_group = process_turns.player_array

	for i in target_group:
		i.target()

	process_actions.target = target_group

func reset_target():
	index = 0
	for actor in process_turns.actors:
		if is_instance_valid(actor): actor.untarget()

	process_actions.target = null

func show_choice():
	targetting = false
	choice.show()
	skill_panel.hide()
	choice.get_child(0).call_deferred('grab_focus')

func show_options():
	skill_panel.grab_focus()
	choice.hide()

func _release_focus():
	dummy_control.grab_focus()


## ACTION MENU SIGNAL PROCESSORS
func _on_attack_pressed() -> void:
	flag = 'Attack'
	_release_focus()
	start_choosing()

func _on_skills_pressed() -> void:
	flag = 'Skills'
	process_turns.current_player.show_skill_menu()
	show_options()

func _on_items_pressed() -> void:
	flag = 'Items'
	process_turns.current_player.show_item_menu()
	show_options()

func _on_guard_pressed() -> void:
	flag = 'Guard'
	_release_focus()
	process_actions.action()

func _on_run_pressed() -> void:
	if get_parent().forced:
		Global.print_to_log('You cannot run!')
		return
	flag = 'Run'
	_release_focus()
	process_actions.action()


## SIGNALS
func _on_skill_panel_item_activated(idx: int) -> void:
	_release_focus()
	process_turns.current_player.active_selection = idx

	var aoe_check: bool = false
	if flag == 'Skills':
		var skill: Skill = process_turns.current_player.get_skills()[process_turns.current_player.active_selection]
		if skill.aoe:
			aoe_check = true
		if skill.universal:
			process_actions.target = process_turns.actors
			process_actions.action()
			return
		if not skill.targetable:
			process_actions.target = process_turns.current_player
			process_actions.action()
			return
		if skill is Offensive_Skill:
			offense = true
		if skill is Heal_Skill:
			offense = false
	if flag == 'Items':
		var item: Item = process_turns.current_player.items.get_item(skill_panel.list.get_item_text(idx))
		if item.aoe:
			aoe_check = true
		if item.universal:
			process_actions.target = process_turns.actors
			process_actions.action()
			return

		offense = item.offensive

	if aoe_check:
		start_choosing_aoe()
	else:
		start_choosing()

func _on_skill_panel_item_selected(_index: int) -> void:
	if desc_box.visible:
		desc_box.hide()
