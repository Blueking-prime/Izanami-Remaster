extends Node

class_name BattleInput

@export var choice: Control
@export var skill_panel: Options
@export var dummy_control: Control
@export var desc_box: Control
@export var dummy_option: Button

@export var attack_button: Button
@export var skills_button: Button
@export var items_button: Button
@export var guard_button: Button
@export var run_button: Button

@onready var setup: BattleSetup = get_parent().setup
@onready var process_turns: BattleTurns = get_parent().process_turns
@onready var process_actions: BattleActions = get_parent().process_actions

var current_player: Player:
	get():
		return process_turns.current_player

var target:
	get():
		return process_actions.target
	set(arg):
		process_actions.target = arg

var actors: Array:
	get():
		return process_turns.actors

var targetting: bool = false
var index: int = 0
var flag: StringName
var aoe_targetting: bool = false
var target_group: Array = []
var offense: bool = true
var input_disabled: bool = false

func toggle_option_selectable(state: bool):
	for i in choice.get_children():
		if i is Button:
			i.disabled = not state

## TARGETTING
func _left_press():
	if aoe_targetting:
		switch_focus_aoe()
	else:
		if index > 0:
			index -= 1
			switch_focus(index, index + 1)
		else:
			index = actors.size() - 1
			switch_focus(index, 0)

func _right_press():
	if aoe_targetting:
		switch_focus_aoe()
	else:
		if index < actors.size() - 1:
			index += 1
			switch_focus(index, index - 1)
		else:
			index = 0
			switch_focus(index, actors.size() - 1)

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
		if key < actors.size():
			switch_focus(key, index)
			index = key

func _cancel_targetting():
	current_player.reset_menu()
	skill_panel.hide()
	show_choice()
	reset_target()

## TARGET FOCUS FUNCTIONS
func switch_focus(x, y):
	actors[y].untarget()
	target = actors[x]
	actors[x].target()

func switch_focus_aoe():
	if target_group == process_turns.enemy_array:
		target_group = process_turns.player_array
	else:
		target_group = process_turns.enemy_array

	reset_target()
	for i in target_group:
		i.target()

	target = target_group

func start_choosing():
	targetting = true
	reset_target()
	if offense:
		index = process_turns.player_array.size()

	actors[index].target()
	target = actors[index]

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

	target = target_group

func reset_target():
	index = 0
	for actor in actors:
		if is_instance_valid(actor): actor.untarget()

	target = null

func show_choice():
	toggle_option_selectable(true)
	targetting = false
	choice.show()
	skill_panel.hide()
	if current_player in Checks.battle_option:
		choice.get_child(Checks.battle_option[current_player]).call_deferred('grab_focus')
	else:
		choice.get_child(0).call_deferred('grab_focus')

func show_options():
	skill_panel.enable()
	skill_panel.grab_focus()
	print(current_player)
	match flag:
		'Items':
			if current_player in Checks.item_option:
				skill_panel.get_item_option(Checks.item_option[current_player]).call_deferred('grab_focus')
		'Skills':
			if current_player in Checks.skill_option:
				skill_panel.get_item_option(Checks.skill_option[current_player]).call_deferred('grab_focus')

	choice.hide()

func _release_focus():
	dummy_control.grab_focus()


## ACTION MENU SIGNAL PROCESSORS
func _on_attack_pressed() -> void:
	toggle_option_selectable(false)
	flag = 'Attack'
	Checks.set_action_persistence(current_player, attack_button.get_index())
	_release_focus()
	start_choosing()

func _on_skills_pressed() -> void:
	toggle_option_selectable(false)
	flag = 'Skills'
	Checks.set_action_persistence(current_player, skills_button.get_index())
	current_player.show_skill_menu(skill_panel)
	show_options()

func _on_items_pressed() -> void:
	toggle_option_selectable(false)
	flag = 'Items'
	Checks.set_action_persistence(current_player, items_button.get_index())
	current_player.show_item_menu(skill_panel)
	show_options()

func _on_guard_pressed() -> void:
	toggle_option_selectable(false)
	flag = 'Guard'
	Checks.set_action_persistence(current_player, guard_button.get_index())
	_release_focus()
	process_actions.action()

func _on_run_pressed() -> void:
	toggle_option_selectable(false)
	if get_parent().forced:
		Global.print_to_log('You cannot run!')
		return
	var confirm = await  Global.show_confirmation_box("Do you want to run?")
	if not confirm:
		toggle_option_selectable(true)
		return
	flag = 'Run'
	Checks.set_action_persistence(current_player, run_button.get_index())
	_release_focus()
	process_actions.action()


## SIGNALS
func _on_skill_panel_item_activated(idx: int) -> void:
	_release_focus()
	current_player.active_selection = idx
	skill_panel.disable()

	var aoe_check: bool = false
	if flag == 'Skills':
		Checks.set_skill_persistence(current_player, idx)
		var skill: Skill = current_player.get_skills()[current_player.active_selection]
		if skill.aoe:
			aoe_check = true
		if skill.universal:
			target = actors
			process_actions.action()
			return
		if not skill.targetable:
			target = current_player
			process_actions.action()
			return
		if skill is Offensive_Skill:
			offense = true
		if skill is Heal_Skill:
			offense = false
	if flag == 'Items':
		Checks.set_item_persistence(current_player, idx)
		var item: Item = current_player.items.get_item(skill_panel.get_item_text(idx))
		if item.aoe:
			aoe_check = true
		if item.universal:
			target = actors
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

func _on_skill_panel_hidden() -> void:
	if not desc_box.visible and not skill_panel.visible:
		desc_box.show()
