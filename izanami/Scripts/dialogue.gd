extends Node

## INFO ##
# CUTSCENE SPEAKER TEXT FROMAT:[ SPEAKER, TEXT, CHOICES, UNSKIPPABLE_FLAG ]
# Place choices above parents as in 'test_cutscene'
# {br}

@export var auto_delay_timer: Timer
@export var file_reader: CutsceneReader

@export var canvas_layer: CanvasLayer
@export var textlog: TextLog

var PLAYER_NAME: String = 'Player'
var cutscene: Dictionary


func _ready() -> void:
	show_cutscene('test_cutscene')


func parse_branch(branch: Dictionary):
	set_flags(branch.flags)

	for i in branch.dialogue:
		Global.add_to_text_log(i)

		if Global.textbox_auto_flag:
			auto_delay_timer.start(_calculate_wait_time(i[1]))

		if Global.textbox_ffwd_flag:
			auto_delay_timer.start(Checks.ffwd_speed)


		if Global.textbox_skip_flag:
			if i.size() >= 4 and i[3]:
				Global.textbox_skip_flag = false
				pass
			else :
				continue

		# Check if text has options
		if i.size() >= 3 and i[2] != []:
			var choice := await Global.show_text_choice(
				i[0], # Speaker
				i[1], # Prompt
				get_valid_choices(i[2]),
				_check_screenside(i[0]),
				true
			)
			await parse_branch(cutscene[i[2][choice].branch])
		else :
			await Global.show_text_box(
				i[0],
				i[1],
				false,
				_check_screenside(i[0]),
				true
			)

		auto_delay_timer.stop()

func show_cutscene(cutscene_name: String):
	var scroll_state: bool = Checks.scroll
	Global.pause_timer.connect(_on_pause_timeout)

	if is_instance_valid(Global.players):
		Global.players.freeze()

	cutscene = file_reader.load_cutscene(cutscene_name)

	if not cutscene.is_empty():
		# Check info
		if check_flags(cutscene.main.checks):
			await parse_branch(cutscene.main)
		else:
			var alt_branch := 1
			while cutscene.get('alt_' + str(alt_branch), false):
				if check_flags(cutscene.get('alt_' + str(alt_branch)).checks):
					await parse_branch(cutscene.get('alt_' + str(alt_branch)))
					break
				alt_branch += 1

	Global.textbox_skip_flag = false
	Checks.scroll = scroll_state
	if is_instance_valid(Global.text_log):
		Global.text_log.hide()

	get_tree().get_current_scene().canvas_layer.remove_child(Global.text_log)

	if is_instance_valid(Global.players):
		Global.players.unfreeze()

func check_flags(flags: Array) -> bool:
	return flags.all(func(x): return Checks.get(x))

func set_flags(flags: Dictionary):
	for i in flags:
		Checks.set(i, flags[i])

func give_rewards(rewards: Array):
	for i in rewards:
		if i.type == 'Skill':
			Global.players.leader.skills.add_skill(Global.get_resource(i.name, i.type))
		else :
			for j in i.quantity:
				Global.players.inventory.add_entry(Global.get_resource(i.name, i.type))

func get_valid_choices(choices: Array) -> Array:
	return choices.filter(func(x): return check_flags(x.checks)).map(func(x): return x.name)

func _calculate_wait_time(text: String):
	return text.split(' ').size() * Checks.scroll_speed * 2 + Checks.wait_time

func _check_screenside(speaker: String) -> String:
	if speaker == "PLAYER_NAME":
		return 'R'
	else :
		return 'L'

func _on_auto_timer_timeout() -> void:
	Global.next.emit()

func _on_pause_timeout() -> void:
	auto_delay_timer.stop()
