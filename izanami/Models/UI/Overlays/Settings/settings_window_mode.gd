extends HBoxContainer

@export var dropdown: OptionButton

const window_modes: Array = [
	'Windowed',
	null,
	'Maximized',
	'Fullscreen',
	'Exclusive Fullscreen',
]

func _ready() -> void:
	for i in window_modes.size():
		if window_modes[i]:
			dropdown.add_item(window_modes[i], i)

	dropdown.selected = Checks.retreive_setting('window_mode')

func _on_option_button_item_selected(index: int) -> void:
	Checks.change_setting('window_mode', dropdown.get_item_id(index))
