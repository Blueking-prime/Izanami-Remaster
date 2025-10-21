extends OptionMenu

class_name SaveMenu


## WORKING VARIABLES
@export var button: Button
@export var title: Label
@export var background: Panel

var saves: Array[GameSaveData]

func load_menu():
	if SaveAndLoad.save_state:
		title.text = "Choose save file"
		button.text = "Create New Save"
	else:
		title.text = "Load from file"
		button.text = "Load Last Save"

	get_saves()
	update_listing()

func get_saves():
	SaveAndLoad.get_save_files()

	saves.clear()
	for i in SaveAndLoad.save_files:
		print(SaveAndLoad.folder_location + i)
		var save_data: GameSaveData = load(SaveAndLoad.folder_location + i)
		print(save_data)
		save_data.name = i
		saves.append(save_data)

func update_listing():
	options.clear()

	if saves: for i in saves:
		options.add_item(
			i.name,
			[
				process_date(i.date),
				(i.scene_data.location).lpad(30, '\t')
			]
		)

func process_date(date_string: String) -> String:
	return " ".join(date_string.split("T"))


func _on_item_activated(index: int) -> void:
	if SaveAndLoad.save_state:
		if index >= 0:
			var confirm = await Global.show_confirmation_box('Do you want to Overwrite this save?')
			if not confirm: return
		hide()
		SaveAndLoad.save_game(index)
	else:
		if not get_tree().get_current_scene() is MainMenu:
			var confirm = await Global.show_confirmation_box('Do you want to Load this save? \n(WARNING! Unsaved progress will be lost!)')
			if not confirm: return
		hide()
		SaveAndLoad.load_game(index)


func _on_button_pressed() -> void:
	_on_item_activated(SaveAndLoad.NO_OPTION_SELECTED)

func _on_exit_button_pressed() -> void:
	hide()

func _set_focus():
	if saves.is_empty():
		button.grab_focus()
	else :
		options.grab_focus()

func _on_visibility_changed() -> void:
	Audio.quiet(visible)
	Audio.play_show_menu_sfx(visible)

	if visible:
		if not Global.exit_signal.is_connected(_on_exit_button_pressed): Global.exit_signal.connect(_on_exit_button_pressed)
		if is_instance_valid(Global.exit_button): Global.exit_button.show()
		background.show()
		_set_focus()
	else :
		if Global.exit_signal.is_connected(_on_exit_button_pressed): Global.exit_signal.disconnect(_on_exit_button_pressed)
		if is_instance_valid(Global.exit_button): Global.exit_button.hide()
		background.hide()

func _input(event: InputEvent) -> void:
	if not visible: return
	var current_focus = get_viewport().gui_get_focus_owner()
	if not is_instance_valid(current_focus): return
	if current_focus is not Button: return
	if not is_ancestor_of(current_focus): return

	if event.is_action_pressed("ui_focus_next") or event.is_action_pressed("ui_focus_prev"):
		if current_focus == button:
			options.grab_focus()
		else :
			button.grab_focus()
