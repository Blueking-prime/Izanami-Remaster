extends Node

class_name GlobalSceneLoader

func warp(source: Location, destination_scene: PackedScene):
	await LoadingScreen.show()

	Global.players.freeze()
	Global.players.leader.velocity = Vector2.ZERO
	if is_instance_valid(source):
		source.hide()
		source.disconnect_signals()

	get_parent().players.leader.global_position = Vector2i.ZERO

	var destination: Location = destination_scene.instantiate()
	destination.hide()
	if is_instance_valid(source):
		source.add_sibling.call_deferred(destination)
		source.call_deferred('remove_players')
	else:
		get_parent().add_sibling.call_deferred(destination)

	destination.call_deferred('add_players')

	await get_tree().create_timer(1).timeout

	get_tree().set_deferred('current_scene', destination)
	if is_instance_valid(source):
		source.call_deferred('queue_free')

	Audio.call_deferred('set_background_music')

	await get_tree().create_timer(1).timeout

	get_parent().players.leader.global_position = destination.entrance

	destination.call_deferred('connect_signals')

	print(destination.get_script().get_global_name(), ' Loaded')
	destination.show()
	await LoadingScreen.hide()

	Global.players.call_deferred('unfreeze')
	SaveAndLoad.call_deferred('save_game', SaveAndLoad.AUTOSAVE_SELECTED)


func load_main_menu():
	var main_menu = get_parent().main_menu_scene.instantiate()
	get_tree().unload_current_scene()
	get_parent().add_sibling(main_menu)
	get_tree().current_scene = main_menu


func move_node_to_other_node(node: Node, parent: Node, other_node: Node, after: int = false):
	if (other_node.get_parent() != parent) or (node.get_parent() != parent):
		print('Parent node not match')
		return

	var target_index: int = other_node.get_index()
	if after: target_index += 1

	parent.move_child(node, target_index)


func get_resource(resource_name: String, type: String) -> Resource:
	var item: Resource
	var index: int
	match type:
		'Gear':
			index = get_parent().all_gears.find_custom(func (x): return x.name == resource_name)
			item = get_parent().all_gears.get(index)
		'Item':
			index = get_parent().all_items.find_custom(func (x): return x.name == resource_name)
			item = get_parent().all_items.get(index)
		'Skill':
			index = get_parent().all_gears.find_custom(func (x): return x.name == resource_name)
			item = get_parent().all_gears.get(index)

	return item

func push_back_player(centre: Vector2, distance: int, tilemap: bool = false, _warp: bool = true):
	var push_velocity_multiplier: int = 10
	var player: Player = Global.players.leader
	var direction: Vector2

	if tilemap:
		direction = centre.direction_to(player.tilemap_position)
		if not _warp: distance *= Location.TILEMAP_CELL_SIZE
	else:
		direction = centre.direction_to(player.global_position)

	if _warp:
		if tilemap: player.tilemap_position += Vector2i(direction.round()) * distance
		else: player.global_position += direction * distance
	else:
		player.velocity = direction * push_velocity_multiplier * distance
		player.get_real_velocity()
		player.move_and_slide()

func spawn_player(player_name: String) -> Player:
	var index = get_parent().all_players.find_custom(func (x): return x.containsn(player_name))
	return get_parent().all_players.get(index).instantiate()
