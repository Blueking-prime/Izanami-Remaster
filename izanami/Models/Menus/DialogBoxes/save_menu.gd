extends OptionMenu

class_name SaveMenu

## EXTERNAL PARAMETERS

## WORKING VARIABLES
var saves: Array[GameSaveData]
var save_state: bool

signal item_activated

func load_stock():
	get_saves()
	update_listing()

func get_saves():
	SaveAndLoad.get_save_files()

	saves.clear()
	for i in SaveAndLoad.save_files:
		var save_data: GameSaveData = load(SaveAndLoad.folder_location + i)
		save_data.name = i
		saves.append(save_data)

func create_save(index = null):
	if index != null:
		SaveAndLoad.create_save_file(SaveAndLoad.folder_location + SaveAndLoad.save_files[index])
	else:
		SaveAndLoad.save_game()

func load_save(index = null):
	if index != null:
		print(index)
		print(SaveAndLoad.save_files[index])
		SaveAndLoad.load_save_file(SaveAndLoad.folder_location + SaveAndLoad.save_files[index])
	else:
		SaveAndLoad.load_game()

func update_listing():
	options.clear()

	if saves: for i in saves:
		options.add_item(
			i.name,
			process_date(i.date),
			(i.scene_data.location).lpad(30, '\t')
		)

func process_date(date_string: String) -> String:
	return " ".join(date_string.split("T"))

func _on_item_activated(index: int) -> void:
	print(index)
	if save_state:
		create_save(index)
	else:
		load_save(index)

	update_listing()
	item_activated.emit()


func _on_button_pressed() -> void:
	print(save_state)
	if save_state:
		create_save()
	else:
		load_save()
	update_listing()
	item_activated.emit()
