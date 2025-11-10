extends HBoxContainer

class_name KeybindOption

@export var label: Label
@export var button: Button

## 0 for keyboard, 1 for controller, etc
@export var input_type: int:
	get(): return Checks.retreive_setting('input_type')
@export var action_name: StringName

func _ready() -> void:
	label.text = action_name.capitalize()
	set_process_unhandled_key_input(false)
	set_key_text()

func _unhandled_key_input(event: InputEvent) -> void:
	rebind_action(event)
	button.button_pressed = false


func get_key_event() -> InputEvent:
	return InputMap.action_get_events(action_name)[Checks.settings_flags.input_type]

func set_key_text():
	button.text = 'Unassigned'

	var event: InputEvent = get_key_event()
	if event is InputEventKey:
		button.text = event.as_text_keycode()


func check_duplicate_assignment(event: InputEvent):
	for i in get_tree().get_nodes_in_group("rebinds"): if i.action_name != action_name:
		match input_type:
			0: if i.get_key_event().keycode == event.keycode: i.call_deferred('rebind_action', get_key_event())

func rebind_action(event: InputEventKey):
	check_duplicate_assignment(event)

	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)

	set_process_unhandled_key_input(false)
	set_key_text()
	print(action_name, ' ', button.text, ' ', get_key_event())

func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		button.text = "Press Any Key"
		set_process_unhandled_key_input(toggled_on)

		for i in get_tree().get_nodes_in_group("rebinds"):
			if i.action_name != action_name:
				i.button.toggle_mode = false
				i.set_process_unhandled_key_input(false)
	else:
		for i in get_tree().get_nodes_in_group("rebinds"):
			if i.action_name != action_name:
				i.button.toggle_mode = true
				i.set_process_unhandled_key_input(false)

		set_key_text()
