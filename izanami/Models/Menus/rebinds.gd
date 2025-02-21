extends HBoxContainer

class_name Rebinder

@export var label: Label
@export var button: Button

@export var action_name: StringName

var action_event: InputEventKey

func _ready() -> void:
	set_process_unhandled_key_input(false)
	set_action_name()
	set_key_text()

func set_action_name():
	button.text = 'Unassigned'
	label.text = action_name.capitalize()

func set_key_text():
	action_event = InputMap.action_get_events(action_name)[0]
	button.text = action_event.as_text_physical_keycode()


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

func _unhandled_key_input(event: InputEvent) -> void:
	rebind_action(event)
	button.button_pressed = false

func rebind_action(event: InputEventKey):
	for i in get_tree().get_nodes_in_group("rebinds"):
		#print(i.name)
		#print(i.button.text)
		#print(action_event.as_text_physical_keycode())
		if i.action_name != action_name and i.button.text == action_event.as_text_physical_keycode():
			return

	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)

	set_process_unhandled_key_input(false)
	set_key_text()
	set_action_name()
