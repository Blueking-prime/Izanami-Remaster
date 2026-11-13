extends Area2D

class_name CutsceneTrigger

@export var cutscenes: Dictionary [StateHandler.STATE, Resource] = {}

var current_cutscene: JSON

func set_cutscene():
	if cutscenes.has(Checks.state):
		current_cutscene = cutscenes[Checks.state]
	else :
		hide()

func dialogue():
	await Dialogue.show_cutscene(current_cutscene)
	hide()


#func _test_states():
	#var confirm = await Global.show_confirmation_box('Do you want to change your state? ')
	#if confirm:
		#Checks.state = StateHandler.STATE.POST_KINTA
		#get_parent().set_scene_state()
