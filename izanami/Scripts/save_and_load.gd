extends Node

@export_dir var folder_location: String = "user://save_files/"

var save_files: Array
var count: int

func save_game():
	get_save_files()

	var file_location = folder_location + "save_%d.tres" % [count + 1]
	create_save_file(file_location)

func load_game():
	get_save_files()

	if save_files.back():
		var file_location = folder_location + save_files.back()

		load_save_file(file_location)


## PROCESS FILE DIRECTORY
func get_save_files():
	if not DirAccess.dir_exists_absolute(folder_location):
		DirAccess.make_dir_recursive_absolute(folder_location)

	save_files = DirAccess.open(folder_location).get_files()
	count = save_files.size()


## PROCESS SAVE FILE DATA
func create_save_file(file_location: String):
	var save_file:GameSaveData = GameSaveData.new()

	save_file.date = Time.get_datetime_string_from_system()
	save_file.party_data = Global.player_party.save()
	save_file.scene_data = get_tree().current_scene.save()
	print(file_location, save_file)

	ResourceSaver.save(save_file, file_location)
	print('saved!')

func load_save_file(file_location: String):
	var save_file: GameSaveData = load(file_location)
	print(file_location, save_file)

	match save_file.scene_data.location:
		'Town': await load_town()
		'Dungeon': await load_dungeon(save_file.scene_data)

	if not Global.player_party:
		load_players()

	Global.player_party.load_state(save_file.party_data)

	get_tree().current_scene.load_data(save_file.scene_data)
	get_tree().current_scene.load_scene()

	print('loaded')


## LOAD SCENE
func load_town():
	if not get_tree().current_scene is Town:
		get_tree().unload_current_scene()
		var town: Town = preload("res://Scenes/Town/town.tscn").instantiate()
		add_sibling(town)
		get_tree().current_scene = town

	print('Town Loaded')

func load_dungeon(scene_data: DungeonSaveData):
	if not get_tree().current_scene is Dungeon:
		get_tree().unload_current_scene()
		var dungeon: Town = preload("res://Scenes/Dungeon/dungeon.tscn").instantiate()

		dungeon.width = scene_data.width
		dungeon.height = scene_data.height
		dungeon.enemy_types = scene_data.enemy_types
		dungeon.item_drop_group = scene_data.item_drop_group
		dungeon.gear_drop_group = scene_data.gear_drop_group
		dungeon.MAX_ENEMIES = scene_data.MAX_ENEMIES
		dungeon.enemy_spawn_chance = scene_data.enemy_spawn_chance
		dungeon.treasure_spawn_chance = scene_data.treasure_spawn_chance
		dungeon.gear_chance = scene_data.gear_chance

		add_sibling(dungeon)
		get_tree().current_scene = dungeon

	print("Dungeon Loaded")

## SPAWN NEW PLAYERS ON FRESH LOAD
func load_players():
	var players: Party = preload("res://Models/Characters/Players/players.tscn").instantiate()
	Global.player_party =  players
