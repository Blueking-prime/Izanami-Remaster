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

		var search_result = Global.custom_tags_filter.search(word)
		if search_result:
			word = await process_custom_tag(search_result, word)
		await scroll_timer.timeout
		text.text += word + ' '
	scroll_timer.stop()

func process_custom_tag(result: RegExMatch, _text: String) -> String:
	_text = Global.custom_tags_filter.sub(_text, '')
	match result.get_string(1):
		'br': await _break(result)

	return _text

func _break(result: RegExMatch):
	await get_tree().create_timer(result.get_string(2).to_int()).timeout

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
