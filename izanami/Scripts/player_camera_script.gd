extends Camera2D

class_name PlayerCam

var screen_size: Vector2
var tilemap_boundary: Rect2

func init_camera():
	screen_size = get_viewport_rect().size / zoom.x

	if is_instance_valid(get_parent().tilemap):
		tilemap_boundary = get_parent().tilemap.get_used_rect()
		if tilemap_boundary.has_area():
			limit_left = (tilemap_boundary.position.x + 1) * Location.TILEMAP_CELL_SIZE
			limit_top = (tilemap_boundary.position.y + 1) * Location.TILEMAP_CELL_SIZE
			limit_right = (tilemap_boundary.end.x - 1) * Location.TILEMAP_CELL_SIZE
			limit_bottom = (tilemap_boundary.end.y - 1) * Location.TILEMAP_CELL_SIZE

		position = get_parent().center()

	if is_instance_valid(Global.players):
		Global.players.camera = self
		if not Global.players.leader.moved.is_connected(_track_player):
			Global.players.leader.moved.connect(_track_player)

		_track_player()

func _track_player():
	if screen_size < get_parent().size():
		position = Global.players.leader.global_position
