extends Area2D

class_name PlayerDetector

# TILEMAP SIGNALS
var on_enter_signals := ['chest', 'exit', 'entrance']
signal hit_entrance
signal hit_exit

var coord_signals := ['chest']
signal hit_chest(coord)

var on_exit_signals := ['chunk_border', 'entrance']
signal left_chunk_border(chunk)
signal left_entrance

signal hit_enemy(body)

## TOWN SIGNALS
signal hit_building(body)

func _process_tile_collison(body: TileMapLayer, body_rid: RID) -> String:
	return body.get_cell_tile_data(body.get_coords_for_body_rid(body_rid)
		).get_custom_data_by_layer_id(0).to_lower()

func _on_body_shape_entered(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is TileMapLayer:
		var sig := _process_tile_collison(body, body_rid)
		if sig in on_enter_signals:
			if sig in coord_signals:
				emit_signal('hit_' + sig, body.get_coords_for_body_rid(body_rid))
			else:
				emit_signal('hit_' + sig)
	if body is CollisionObject2D:
		if body.get_collision_layer_value(5):
			hit_enemy.emit(body)
		if body.get_collision_layer_value(6):
			hit_building.emit(body)


func _on_area_entered(area: Area2D) -> void:
	if area.get_collision_layer_value(7):
		Global.players.warp_players(area)


func _on_body_shape_exited(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is TileMapLayer:
		var sig := _process_tile_collison(body, body_rid)
		match sig:
			'chunk_border': left_chunk_border.emit(body)
			'entrance': left_entrance.emit()
