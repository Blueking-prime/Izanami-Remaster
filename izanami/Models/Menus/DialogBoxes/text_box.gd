extends Control

class_name TextBox

@export var title: Label
@export var title_container: PanelContainer
@export var text_box: PanelContainer
@export var text: RichTextLabel
@export var spacer: Control
@export var options: Options

@export var button_panel: PanelContainer

@export var skip_button: Button
@export var log_button: Button
@export var auto_button: Button
@export var ffwd_button: Button

@export var scroll_timer: Timer

var text_string: String

func scroll_text():
	scroll_timer.start()
	text.text = ''
	for word in text_string.split(' '):
		if scroll_timer.is_stopped(): break

		var search_result: Array = Global.custom_tags_filter.search_all(word)
		if search_result:
			word = await process_custom_tag(search_result, word)
		await scroll_timer.timeout
		text.text += word + ' '
	scroll_timer.stop()

func process_custom_tag(result: Array[RegExMatch], _text: String) -> String:
	for i in result:
		var replacement_text := ''
		match i.get_string(Global.REGEX_TAG_GROUP):
			'br': await _break(i)
			'gr': replacement_text = _whisper(i)
			'sm': replacement_text = _small(i)

		_text = Global.custom_tags_filter.sub(_text, replacement_text)

	return _text

func _break(result: RegExMatch):
	await get_tree().create_timer(result.get_string(Global.REGEX_VALUE_GROUP).to_int()).timeout

func _whisper(result: RegExMatch) -> String:
	if result.get_string(Global.REGEX_SLASH_GROUP):
		return r'[/color]'
	else :
		return '[color=#%s]' % [Checks.thought_text_colour.to_html()]

func _small(result: RegExMatch):
	if result.get_string(Global.REGEX_SLASH_GROUP):
		return r'[/font_size]'
	else :
		return '[font_size=%d]' % [Checks.small_text_size]

func _go_next():
	if Checks.scroll and not scroll_timer.is_stopped():
		scroll_timer.stop()
		text.text = Global.clear_custom_tags(text_string)
	else:
		Global.next.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_go_next()

func _on_text_box_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		_go_next()
