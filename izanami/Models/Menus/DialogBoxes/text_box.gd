extends Control

class_name TextBox

@export var title: Label
@export var title_container: PanelContainer
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
		for tag in Global.custom_tags.values():
			var search_result = tag.search(word)
			if search_result:
				word = await process_custom_tag(tag, search_result, word)
			else :
				continue
		await scroll_timer.timeout
		text.text += word + ' '
	scroll_timer.stop()

func process_custom_tag(tag: RegEx, result: RegExMatch, _text: String) -> String:
	_text = tag.sub(_text, '')
	match tag:
		Global.custom_tags.BR: await _break(result)

	return _text

func _break(result: RegExMatch):
	await get_tree().create_timer(result.get_string(1).to_int()).timeout


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		#print('Enter pressed')
		Global.next.emit()

func _on_text_box_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		Global.next.emit()
