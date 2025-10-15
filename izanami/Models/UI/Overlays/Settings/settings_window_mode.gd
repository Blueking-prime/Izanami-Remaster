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

	dropdown.selected = Checks.settings_flags.window_mode

func _on_option_button_item_selected(index: int) -> void:
	var mode := dropdown.get_item_id(index)
	Checks.settings_flags.window_mode = mode
