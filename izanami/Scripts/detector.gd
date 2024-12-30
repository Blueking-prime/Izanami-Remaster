extends Area2D

signal object_hit(object_type)
signal hit_chest
signal hit_enemy

var current_tilemap: TileMapLayer

func _process_collison(body: Node2D, body_rid: RID):
	current_tilemap = body
	
	
	var collided_tile_coords = current_tilemap.get_coords_for_body_rid(body_rid)
	var tile_data = current_tilemap.get_cell_tile_data(collided_tile_coords)
	var mask = tile_data.get_custom_data_by_layer_id(0)
	
	_update_collision(mask)
	
func _update_collision(mask):
	emit_signal("object_hit", mask)
	

func _on_body_shape_entered(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is TileMapLayer:
		_process_collison(body, body_rid)
