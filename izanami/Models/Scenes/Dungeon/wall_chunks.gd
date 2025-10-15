extends Node2D

class_name WallChunkLoader

@onready var root_node: Dungeon:
	get(): return get_parent().get_parent()
@onready var map: DungeonMap:
	get(): return root_node.map

@export var chunk_scene: PackedScene

enum DIRECTION { RIGHT, DOWN, LEFT, UP, CENTER}
var switching: bool = false:
	set(arg):
		switching = arg
		if arg:
			Global.players.freeze()
		else:
			Global.players.unfreeze()

var chunk_tiles: Array = []
var current_chunk: DungeonChunk:
	get(): return root_node.tilemap
	set(arg): root_node.tilemap = arg

func load_chunks(new_map: bool):
	chunk_tiles.resize(5)

	var index := 0
	if new_map:
		while map.chunks[index].start.is_empty():
			index += 1
		current_chunk = load_new_chunk(DIRECTION.CENTER, index)
		root_node.player.tilemap_position = current_chunk.entrance.clamp(
			Vector2i(2, 2), Vector2i(map.width - 2, map.height -2)
		)
	else :
		index = current_chunk.chunk_no

	#load adjacent tiles
	# Right
	if index + map.chunk_length < map.chunks.size():
		call_deferred('load_new_chunk', DIRECTION.RIGHT, index + map.chunk_length)
	# Left
	if index - map.chunk_length >= 0:
		call_deferred('load_new_chunk', DIRECTION.LEFT, index - map.chunk_length)
	# Up
	if index != 0 and index % map.chunk_length != 0:
		call_deferred('load_new_chunk', DIRECTION.UP, index - 1)
	# Down
	if index % map.chunk_length != map.chunk_length - 1:
		call_deferred('load_new_chunk', DIRECTION.DOWN, index + 1)

	root_node.camera.tilemap_position = current_chunk.rect.get_center()



func load_new_chunk(pos: int, index: int) -> DungeonChunk:
	if is_instance_valid(chunk_tiles[pos]): return

	var chunk: DungeonChunk = chunk_scene.instantiate()
	chunk.chunk_no = index

	add_child(chunk)

	chunk.render_objects()
	chunk_tiles[pos] = chunk

	return chunk


func unload_chunk(chunk: DungeonChunk):
	if is_instance_valid(chunk): chunk.queue_free()

func update_player_chunk(chunk: DungeonChunk):
	if current_chunk == chunk: return
	if not is_instance_valid(chunk): return
	if switching: return

	switching = true

	# Keep player from loitering on border
	Global.players.freeze()
	root_node.player.detector.left_chunk_border.disconnect(root_node._on_detector_hit_border)

	var direction := _get_chunk_direction(chunk)
	var target_point: Vector2i = chunk.rect.get_center()
	if direction % 2:
		target_point.x = root_node.player.tilemap_position.x
	else:
		target_point.y = root_node.player.tilemap_position.y

	Global.push_back_player(target_point, - 2 , true, false)

	# Check if player in target chunk
	if not confirm_player_location(chunk):
		root_node.player.detector.left_chunk_border.connect(root_node._on_detector_hit_border)
		Global.players.unfreeze()
		switching = false
		return

	for i in chunk_tiles:
		if i != current_chunk and i != chunk:
			unload_chunk(i)

	chunk_tiles.fill(null)
	# Set central node
	chunk_tiles[DIRECTION.CENTER] = chunk
	# Gets reverse direction
	chunk_tiles[_get_reverse_direction(direction)] = current_chunk
	current_chunk = chunk

	await root_node.camera.move_camera(current_chunk.rect.get_center())

	await get_tree().create_timer(0.1).timeout

	root_node.player.detector.left_chunk_border.connect(root_node._on_detector_hit_border)
	Global.players.unfreeze()
	switching = false
	load_chunks(false)


func _get_chunk_direction(chunk: DungeonChunk) -> int:
	var angle := Vector2(current_chunk.rect.get_center()).angle_to_point(chunk.rect.get_center())
	var direction = 0
	angle = rad_to_deg(angle) + 45 # Rotate to align quadrants with cardinal directions
	if angle < 0: angle += 360 # Convert negative angles

	if angle < 90:
		direction = DIRECTION.RIGHT
	elif angle < 180:
		direction = DIRECTION.DOWN
	elif angle < 270:
		direction = DIRECTION.LEFT
	else:
		direction = DIRECTION.UP

	return direction

func _get_reverse_direction(direction: int) -> int:
	return (direction + 2) % 4


func confirm_player_location(chunk: DungeonChunk) -> bool:
	if chunk.rect.has_point(root_node.player.tilemap_position):
		return true
	else:
		return false
