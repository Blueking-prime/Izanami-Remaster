extends Node

class_name Save

'''SAVE DATA STRUCTURE
	type: 'location saved from '
'''

var file_location: String = "user://save_file.tres"

func save_game():
	var save_file:GameSaveData = GameSaveData.new()

	save_file.party_data = Global.player_party.save()
	save_file.scene_data = get_tree().current_scene.save()

	ResourceSaver.save(save_file, file_location)
	print('saved!')

func load_game():
	var save_file: GameSaveData = load(file_location)

	match save_file.scene_data.location:
		'Town': load_town(save_file.scene_data)
		'Dungeon': load_dungeon(save_file.scene_data)

	Global.player_party.load_state(save_file.party_data)

	print('loaded')

func load_town(save_data: TownSaveData):
	if not get_tree().current_scene is Town:
		get_tree().unload_current_scene()
		var town = preload("res://Scenes/Town/town.tscn").instantiate()
		print(town)
		var town_players = town.get_node("Players")

		call_deferred('add_sibling', town)
		get_tree().current_scene = town
		print(get_tree().current_scene)

	get_tree().current_scene.load_data(save_data)

	print('Town Loaded')


func load_dungeon(save_data):
	pass
