extends Area2D

class_name PlayerDetector

## DUNGEON SIGNALs
signal hit_chest(coords)
signal hit_enemy(coords)
signal hit_exit(coords)
signal hit_entrance(coords)

## TOWN SIGNALS
signal hit_building(body)

func _process_tile_collison(body: TileMapLayer, body_rid: RID):
	var collided_tile_coords = body.get_coords_for_body_rid(body_rid)
	var tile_data = body.get_cell_tile_data(collided_tile_coords)

	var sig = 'hit_' + tile_data.get_custom_data_by_layer_id(0).to_lower()
	emit_signal(sig, collided_tile_coords)


func _on_body_shape_entered(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is TileMapLayer:
		_process_tile_collison(body, body_rid)
	if body is CollisionObject2D:
		if body.get_collision_layer_value(5):
			hit_enemy.emit(body)
		if body.get_collision_layer_value(6):
			hit_building.emit(body)


func _on_area_entered(area: Area2D) -> void:
	if area.get_collision_layer_value(7):
		Global.players.warp_players(area)
