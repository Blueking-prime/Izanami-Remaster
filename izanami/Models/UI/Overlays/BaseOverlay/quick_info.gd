extends PanelContainer

class_name QuickInfoPanel

@export var label: Label
@export var timer: Timer

func display_info(text: String):
	label.text = text
	show()
	timer.start()
	print('Info')

func _on_timer_timeout() -> void:
	hide()
