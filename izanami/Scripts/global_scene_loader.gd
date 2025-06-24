extends Node

class_name GlobalSceneLoader


func warp(source: Location, destination_scene: PackedScene):
	var destination: Location = destination_scene.instantiate()
	source.add_sibling(destination)

	source.remove_players()
	destination.add_players(get_parent().players)

	# Set destination as main scene
	get_tree().current_scene = destination

	# Reload destination and delete current scene
	destination.load_scene()
	source.call_deferred('queue_free')

	get_parent().players.leader.global_position = destination.entrance

	print(get_tree().current_scene)

	print('Town Loaded')


func load_main_menu():
	var main_menu = get_parent().main_menu_scene.instantiate()
	get_tree().unload_current_scene()
	add_sibling(main_menu)
	get_tree().current_scene = main_menu
