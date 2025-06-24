extends Node

## INFO ##
# CUTSCENE SPEAKER TEXT FROMAT:[ SPEAKER, TEXT, CHOICES, CHOICE_PATHS, UNSKIPPABLE_FLAG ]
# Place choices above parents as in 'test_cutscene'
# {br} not yet implemented

@export var auto_delay_timer: Timer

@export var players: Party
@export var canvas_layer: CanvasLayer
@export var textlog: TextLog

var PLAYER_NAME: String = 'Player'

var scroll: bool = true

@export var scroll_speed: float = 0.05
@export var ffwd_speed: float = 0.3
@export var wait_time: float = 1





var test_cutscene_choice_1: Array = [
	['Speaker 1', 'Yes.\nThe next message won\'t clear even if skipping is enabled'],
	[PLAYER_NAME, 'Is that so?', ['Yes, Yes it is'], [], true],
	['Speaker 1', 'There you have it'],
]
var test_cutscene_choice_2: Array = [
	['Speaker 1', 'Nothing really happens on this route'],
	[PLAYER_NAME, 'You have got to be kidding me'],

]

var test_cutscene: Array = [
	['Speaker 1', 'Hello'],
	[PLAYER_NAME, 'Hi'],
	['Speaker 1', 'This is a [b]cutscene[/b] test'],
	[PLAYER_NAME, 'Is it now?'],
	[PLAYER_NAME, 'Who\'d have thunk?'],
	['Speaker 1', 'Well. \n{br:1}Now that we\'re here. \n{br:1}Might as well test out some features'],
	[PLAYER_NAME, 'Like what?', ['Unskippable Choice', 'Option 2'], [test_cutscene_choice_1, test_cutscene_choice_2], true],
	['Speaker 1', 'Well now that we\'re through with that'],
	['Speaker 1', 'It\'s probably time we end this cutscene'],
	[PLAYER_NAME, 'I couldn\'t agree more'],
]


func _ready() -> void:
	Global.players = players
	Global.pause_timer.connect(_on_pause_timeout)

	show_cutscene(test_cutscene)

func parse_cutscene(cutscene: Array):
	for i in cutscene:
		Global.add_to_text_log(i)

		if Global.textbox_auto_flag:
			auto_delay_timer.start(_calculate_wait_time(i[1]))

		if Global.textbox_ffwd_flag:
			auto_delay_timer.start(ffwd_speed)
			scroll = false
		else :
			scroll = true

		if Global.textbox_skip_flag:
			if i.size() >= 5 and i[4]:
				Global.textbox_skip_flag = false
				pass
			else :
				continue

		# Check if text has options
		if i.size() >= 3 and i[2] != []:
			var choice = await Global.show_text_choice(
				i[0],
				i[1],
				i[2],
				_check_screenside(i[0]),
				scroll,
				true
			)
			if i.size() >= 4 and i[3] != []:
				await parse_cutscene(i[3][choice])
		else :
			await Global.show_text_box(
				i[0],
				i[1],
				false,
				_check_screenside(i[0]),
				scroll,
				true
			)

		auto_delay_timer.stop()

func show_cutscene(cutscene: Array):
	Global.players.freeze()

	await parse_cutscene(cutscene)

	Global.textbox_skip_flag = false
	scroll = true
	Global.text_log.hide()

	get_tree().get_current_scene().canvas_layer.remove_child(Global.text_log)

	Global.players.unfreeze()


func _calculate_wait_time(text: String):
	return text.split(' ').size() * scroll_speed * 2 + wait_time

func _check_screenside(speaker: String) -> String:
	if speaker == PLAYER_NAME:
		return 'R'
	else :
		return 'L'

func _on_auto_timer_timeout() -> void:
	Global.next.emit()

func _on_pause_timeout() -> void:
	auto_delay_timer.stop()
