extends Node

class_name ChecksInputMap

const CONFIG_FILE_PATH = "user://input_map.cfg"

enum INPUT_TYPE { KEY, JOY_BUTTON, JOY_AXIS }

func save_input_map():
	var config = ConfigFile.new()
	for action in InputMap.get_actions():
		if action.begins_with("ui_") or action.begins_with("debug_"):
			continue

		var events = InputMap.action_get_events(action)
		var key_codes = []
		for event in events:
			if event is InputEventKey:
				key_codes.append([ INPUT_TYPE.KEY, event.get_keycode_with_modifiers()])
			elif event is InputEventJoypadButton:
				key_codes.append([ INPUT_TYPE.JOY_BUTTON, event.button_index])
			elif event is InputEventJoypadMotion:
				key_codes.append([ INPUT_TYPE.JOY_AXIS, event.axis])
		if not key_codes.is_empty():
			config.set_value("InputMap", action, key_codes)

	config.save(CONFIG_FILE_PATH)

func load_input_map():
	var config = ConfigFile.new()
	var error = config.load(CONFIG_FILE_PATH)
	if error != OK:
		print("Error loading input map: " + str(error))
		return

	for action in config.get_section_keys("InputMap"):
		var key_codes = config.get_value("InputMap", action)

		for existing_event in InputMap.action_get_events(action):
			InputMap.action_erase_event(action, existing_event)

		for key_code in key_codes:
			var event: InputEvent
			match key_code[0]:
				INPUT_TYPE.KEY:
					event = InputEventKey.new()
					event.keycode = key_code[1]
				INPUT_TYPE.JOY_BUTTON:
					event = InputEventJoypadButton.new()
					event.button_index = key_code[1]
				INPUT_TYPE.JOY_AXIS:
					event = InputEventJoypadMotion.new()
					event.axis = key_code[1]
			InputMap.action_add_event(action, event)
