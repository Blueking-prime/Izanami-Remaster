extends VBoxContainer

@export var text_scroll: CheckButton

func _ready() -> void:
	text_scroll.set_pressed_no_signal(Checks.retreive_setting('scroll'))

func _on_text_scroll_toggled(toggled_on: bool) -> void:
	Checks.change_setting('scroll', toggled_on)
