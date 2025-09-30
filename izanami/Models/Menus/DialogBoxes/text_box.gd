extends Control

class_name TextBox

@export var title: Label
@export var title_container: HBoxContainer
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
		#!info: I've lowkey forgotten what this line was supposedto do. but it breaks the first texbox displayed because the timer doesn't start on time. Tbh I don't even remember why this timer is here.
		#if scroll_timer.is_stopped(): break

		word = await Global.process_text_tags(word)

		await scroll_timer.timeout
		text.text += word + ' '
	scroll_timer.stop()


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
