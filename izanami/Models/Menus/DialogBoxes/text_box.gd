extends Control

class_name TextBox

@export var title: Label
@export var title_container: PanelContainer
@export var text: Label
@export var spacer: Control
@export var options: Options

@export var button_panel: PanelContainer

@export var skip_button: Button
@export var log_button: Button
@export var auto_button: Button

@export var scroll_timer: Timer

var text_string: String

func scroll_text():
	scroll_timer.start()
	text.text = ''
	for i in text_string.split(' '):
		text.text += i + ' '
		await scroll_timer.timeout
	scroll_timer.stop()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		#print('Enter pressed')
		Global.next.emit()

func _on_text_box_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		Global.next.emit()
