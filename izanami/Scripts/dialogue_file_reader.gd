extends Node

class_name CutsceneReader

@export var cutscenes: ResourceGroup

func load_cutscene(cutscene_name: String) -> Dictionary:
	var file_name: String = cutscenes.base_folder + '/' + cutscene_name + '.json'
	var data = JSON.parse_string(FileAccess.get_file_as_string(file_name))
	if data:
		return data
	else :
		return {}
