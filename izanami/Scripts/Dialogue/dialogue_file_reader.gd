extends Node

class_name CutsceneReader

@export var cutscenes: ResourceGroup

var loop_choice_skip_template: Dictionary = {"flags": {}, "rewards": {}, "dialogue": []}

func load_cutscene(cutscene_file_name: String) -> Dictionary:
	#var file_name: String = cutscenes.base_folder + '/' + cutscene_name + '.json'
	var data = JSON.parse_string(FileAccess.get_file_as_string(cutscene_file_name))
	if data:
		data['loop_skip'] = loop_choice_skip_template
		return data
	else :
		return {}
