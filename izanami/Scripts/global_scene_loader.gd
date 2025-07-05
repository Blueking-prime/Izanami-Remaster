extends Node

class_name GlobalSceneLoader


func warp(source: Location, destination_scene: PackedScene):
	get_parent().change_background(get_parent().loading_screen, true)
	var destination: Location = destination_scene.instantiate()
	source.add_sibling.call_deferred(destination)

	get_parent().players.get_parent().remove_child(get_parent().players)
	destination.add_players(get_parent().players)

	await get_tree().create_timer(3).timeout
	Global.players.unfreeze()
	# Set destination as main scene
	get_tree().current_scene = destination

	# Reload destination and delete current scene
	#destination.load_scene()
	if is_instance_valid(source):
		source.call_deferred('queue_free')

	get_parent().players.leader.global_position = destination.entrance

	print(get_tree().current_scene)

	print('Town Loaded')
	get_parent().change_background(null, true)


func load_main_menu():
	var main_menu = get_parent().main_menu_scene.instantiate()
	get_tree().unload_current_scene()
	add_sibling(main_menu)
	get_tree().current_scene = main_menu


func move_node_to_other_node(node: Node, parent: Node, other_node: Node, after: int = false):
	if (other_node.get_parent() != parent) or (node.get_parent() != parent):
		print('Parent node not match')
		return

	var target_index: int = other_node.get_index()
	if after: target_index += 1

	parent.move_child(node, target_index)


func push_back_player(centre: Vector2, distance: float):
	var player_position: Vector2 = Global.players.leader.global_position
	var direction: Vector2 = centre.direction_to(player_position)

	Global.players.leader.global_position += direction * distance
