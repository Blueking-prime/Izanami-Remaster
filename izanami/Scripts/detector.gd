extends Area2D

signal hit_chest(coords)
signal hit_enemy(coords)
signal hit_exit(coords)

var tile_data: TileData
var collided_tile_coords: Vector2i

@export var checked_masks: Array = ['Chest', 'Exit']


func _process_tile_collison(body: Node2D, body_rid: RID):
	collided_tile_coords = body.get_coords_for_body_rid(body_rid)
	tile_data = body.get_cell_tile_data(collided_tile_coords)
	var mask = tile_data.get_custom_data_by_layer_id(0)
	
	_update_tile_collision(mask)


func _update_tile_collision(mask):
	if mask in checked_masks:
		var sig = 'hit_' + mask.to_lower()
		emit_signal(sig, collided_tile_coords)
		print(sig, collided_tile_coords)


func _on_body_shape_entered(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is TileMapLayer:
		_process_tile_collison(body, body_rid)
	if body is Enemy:
		emit_signal('hit_enemy', body)
