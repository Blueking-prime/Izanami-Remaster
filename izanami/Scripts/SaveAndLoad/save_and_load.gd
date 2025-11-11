extends Node

@export_dir var folder_location: String = "user://save_files/"
var autosave_file: String = "autosave.tres"

var save_files: Array
var save_state: bool

const NO_OPTION_SELECTED = -1
const AUTOSAVE_SELECTED = -2

func save_game(index: int):
	Global.save_icon(true)
	match index:
		NO_OPTION_SELECTED: create_save_file(folder_location + "save_%d.tres" % [save_files.size() + 1])
		AUTOSAVE_SELECTED: create_save_file(folder_location + autosave_file)
		_: create_save_file(folder_location + save_files[index])

func load_game(index: int):
	if index == NO_OPTION_SELECTED:
		if save_files.is_empty():
			Global.show_info_popup('No save files')
		else:
			load_save_file(folder_location + save_files.back())
	else:
		load_save_file(folder_location + save_files[index])

## PROCESS FILE DIRECTORY
func get_save_files():
	if not DirAccess.dir_exists_absolute(folder_location):
		DirAccess.make_dir_recursive_absolute(folder_location)

	save_files = DirAccess.open(folder_location).get_files()
	save_files.erase('system.tres')

## PROCESS SAVE FILE DATA
func create_save_file(file_location: String):
	Global.save_icon(true)
	var save_file:GameSaveData = GameSaveData.new()

	save_file.date = Time.get_datetime_string_from_system()
	save_file.party_data = Global.players.save()
	save_file.scene_data = get_tree().current_scene.save()
	save_file.game_flags = Checks.save_flags()

	ResourceSaver.save(save_file, file_location)
	if not file_location.contains(autosave_file): Global.show_info_popup('saved!')
	Global.save_icon(false)

func load_save_file(file_location: String):
	var save_file: GameSaveData = load(file_location)
	Checks.load_flags(save_file.game_flags)

	match save_file.scene_data.location:
		'Town': await load_town()
		'Demonitarium': await load_demonitarium()

	if not Global.players:
		load_players()

	Global.players.load_state(save_file.party_data)

	get_tree().current_scene.load_data(save_file.scene_data)
	get_tree().current_scene.load_scene()

	Global.call_deferred("show_info_popup", "Loaded")


func save_settings():
	Global.save_icon(true)
	var save_file: SettingsSaveData = SettingsSaveData.new()
	save_file.data = Checks.save_settings()
	ResourceSaver.save(save_file, folder_location + 'system.tres')
	Global.save_icon(false)


func load_settings():
	var save_file: SettingsSaveData = load(folder_location + 'system.tres')
	if save_file is SettingsSaveData:
		Checks.load_settings(save_file.data)

## LOAD SCENE
func load_town():
	if not get_tree().current_scene is Town:
		get_tree().unload_current_scene()
		var town: Town = Global.town_scene.instantiate()
		add_sibling(town)
		get_tree().current_scene = town

func load_demonitarium():
	if not get_tree().current_scene is Demonitarium:
		get_tree().unload_current_scene()
		var demonitarium: Demonitarium = Global.demonitarium_scene.instantiate()
		add_sibling(demonitarium)
		get_tree().current_scene = demonitarium


## SPAWN NEW PLAYERS ON FRESH LOAD
func load_players():
	var players: Party = preload("res://Models/Characters/Players/players.tscn").instantiate()
	Global.players =  players
