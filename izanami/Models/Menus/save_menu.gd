extends Node

class_name SaveMenu

## CHILD NODES
@export var list: ItemList
@export var date: ItemList
@export var location: ItemList

## EXTERNAL PARAMETERS

## WORKING VARIABLES
var saves: Array[GameSaveData]

func _ready() -> void:
	load_stock()

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
	if index:
		SaveAndLoad.create_save_file(SaveAndLoad.folder_location + SaveAndLoad.save_files[index])
	else:
		SaveAndLoad.save_game()

func load_save(index = null):
	if index:
		SaveAndLoad.load_save_file(SaveAndLoad.folder_location + SaveAndLoad.save_files[index])
	else:
		SaveAndLoad.load_game()

func update_listing():
	list.clear()
	date.clear()
	location.clear()

	if saves: for i in saves:
			list.add_item(i.name)
			date.add_item(process_date(i.date))
			location.add_item(i.scene_data.location)

func process_date(date: String) -> String:
	return "\n".join(date.split("T"))

func _on_item_activated(index: int) -> void:
	create_save(index)
	update_listing()

func _on_item_selected(index: int) -> void:
	list.select(index)
	date.select(index)
	location.select(index)
