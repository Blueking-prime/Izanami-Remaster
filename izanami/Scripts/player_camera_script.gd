extends Camera2D

class_name PlayerCam

func init_camera():
	if is_instance_valid(Global.players):
		Global.players.camera = self
		if not Global.players.leader.moved.is_connected(_track_player):
			Global.players.leader.moved.connect(_track_player)

		_track_player()

	if is_instance_valid(get_parent().tilemap):
		var tilemap_boundary: Rect2 = get_parent().tilemap.get_used_rect()
		if tilemap_boundary.has_area():
			limit_left = (tilemap_boundary.position.x + 1) * Location.TILEMAP_CELL_SIZE
			limit_top = (tilemap_boundary.position.y + 1) * Location.TILEMAP_CELL_SIZE
			limit_right = (tilemap_boundary.end.x - 1) * Location.TILEMAP_CELL_SIZE
			limit_bottom = (tilemap_boundary.end.y - 1) * Location.TILEMAP_CELL_SIZE


func _track_player():
	position = Global.players.leader.global_position
