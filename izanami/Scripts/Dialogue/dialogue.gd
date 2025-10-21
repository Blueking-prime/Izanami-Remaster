extends Node

## INFO ##
# CUTSCENE SPEAKER TEXT FROMAT:[ SPEAKER, TEXT, CHOICES, UNSKIPPABLE_FLAG, LOOP_OPTIONS_FLAG ]

@export var auto_delay_timer: Timer
@export var file_reader: CutsceneReader

@export var canvas_layer: CanvasLayer
@export var textlog: TextLog

var PLAYER_NAME: String = 'Player'
var cutscene: Dictionary


#func _ready() -> void:
	#show_cutscene('test_cutscene')


func parse_branch(branch: Dictionary):
	Checks.set_flags(branch.flags)
	var dialogue_length: int = branch.dialogue.size()
	var current_line: int = 0
	var selected_choice: int

	while current_line < dialogue_length:
		var line: Array = branch.dialogue[current_line]
		await Global.add_to_text_log(line)

		if Global.textbox_auto_flag:
			auto_delay_timer.start(_calculate_wait_time(line[1]))

		if Global.textbox_ffwd_flag:
			auto_delay_timer.start(Checks.ffwd_speed)


		if Global.textbox_skip_flag:
			if line.size() >= 4 and line[3]:
				Global.textbox_skip_flag = false
				pass
			else :
				continue

		# Check if text has options
		if line.size() >= 3 and line[2] != []:
			var choices: Array = line[2].duplicate()
			if line.size() >= 5 and line[4] and not line[3]:
				choices.append({ "name": "Nevermind", "branch": "loop_skip", "checks": [] })
			var choice := await Global.show_text_choice(
				line[0], # Speaker
				line[1], # Prompt
				get_valid_choices(choices),
				_check_screenside(line[0]),
				true
			)
			choice = parse_valid_choices(choices, get_valid_choices(choices), choice)
			selected_choice = choice
			await parse_branch(cutscene[choices[choice].branch])
			if choices[choice].branch == 'loop_skip':
				current_line += 1
		else :
			await Global.show_text_box(
				line[0],
				line[1],
				false,
				_check_screenside(line[0]),
				true
			)

		if line.size() >= 5 and line[4]:
			if selected_choice < line[2].size():
				line[2].remove_at(selected_choice)
			if not get_valid_choices(line[2]).is_empty():
				continue

		current_line += 1
		auto_delay_timer.stop()

func show_cutscene(cutscene_name: String):
	var scroll_state: bool = Checks.retreive_setting('scroll')
	Global.pause_timer.connect(_on_pause_timeout)

	if is_instance_valid(Global.players):
		Global.players.freeze()

	cutscene = file_reader.load_cutscene(cutscene_name)

	if not cutscene.is_empty():
		# Check info
		if Checks.check_flags(cutscene.main.checks):
			await parse_branch(cutscene.main)
		else:
			var alt_branch := 1
			while cutscene.get('alt_' + str(alt_branch), false):
				if Checks.check_flags(cutscene.get('alt_' + str(alt_branch)).checks):
					await parse_branch(cutscene.get('alt_' + str(alt_branch)))
					break
				alt_branch += 1

	Global.textbox_skip_flag = false
	Checks.change_setting('scroll', scroll_state)
	if is_instance_valid(Global.text_log):
		Global.text_log.hide()

	get_tree().get_current_scene().canvas_layer.remove_child(Global.text_log)

	if is_instance_valid(Global.players):
		Global.players.unfreeze()

func give_rewards(rewards: Array):
	for i in rewards:
		if i.type == 'Skill':
			Global.players.leader.skills.add_skill(Global.get_resource(i.name, i.type))
		else :
			for j in i.quantity:
				Global.players.inventory.add_entry(Global.get_resource(i.name, i.type))

func get_valid_choices(choices: Array) -> Array:
	return choices.filter(func(x): return Checks.check_flags(x.checks)).map(func(x): return x.name)

func parse_valid_choices(choices: Array, names: Array, index: int) -> int:
	return choices.find_custom(func(x): return x.name == names[index])

func _calculate_wait_time(text: String):
	return text.split(' ').size() * Checks.retreive_setting('scroll_speed') * 2 + Checks.retreive_setting('wait_time')

func _check_screenside(speaker: String) -> String:
	if speaker == "PLAYER_NAME" or speaker == '{pl}':
		return 'R'
	else :
		return 'L'

func _on_auto_timer_timeout() -> void:
	Global.next.emit()

func _on_pause_timeout() -> void:
	auto_delay_timer.stop()
