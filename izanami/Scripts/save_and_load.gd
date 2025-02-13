extends Node

class_name Save

'''SAVE DATA STRUCTURE
	type: 'location saved from '
'''

func save_game():
	var save_file:GameSaveData = GameSaveData.new()

	save_file.party_data = Global.player_party.save()

	ResourceSaver.save(save_file, "user://save_file.tres")
	print('saved!')

func load_game():
	pass
