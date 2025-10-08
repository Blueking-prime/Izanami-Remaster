extends Node2D

class_name WallChunkLoader

@onready var root_node: Dungeon:
	get(): return get_parent().get_parent()
@onready var map: DungeonMap:
	get(): return root_node.map

@export var chunk_scene: PackedScene

var total_chunks: int
var chunk_tiles: Array
var loaded_chunk_indixes: Array

var chunks: Dictionary:
	get(): return map.chunks

func load_chunks():
	total_chunks = chunks.size()

	var index := 0
	while chunks[index].start.is_empty():
		index += 1

	load_new_chunk(index)

	#load adjacent tiles
	# Right
	if index + map.chunk_length < total_chunks:
		load_new_chunk(index + map.chunk_length)
	# Left
	if index - map.chunk_length >= 0:
		load_new_chunk(index - map.chunk_length)
	# Up
	if index != 0 and index % map.chunk_length != 0:
		load_new_chunk(index - 1)
	# Down
	if index % map.chunk_length != map.chunk_length - 1:
		load_new_chunk(index + 1)


func load_new_chunk(index: int):
	if index in loaded_chunk_indixes: return

	var chunk: DungeonChunk = chunk_scene.instantiate()
	chunk.chunk_no = index

	add_child(chunk)

	chunk.render_objects()
	chunk_tiles.append(chunk)
	loaded_chunk_indixes.append(index)


func unload_chunk(): pass
