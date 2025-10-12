extends Camera2D

class_name PlayerCam

@export var fixed: bool = false
@export var fised_move_speed: float = 10

@export var tilemap_position: Vector2i:
	get(): return Vector2i((global_position / Location.TILEMAP_CELL_SIZE).round())
	set(arg): global_position = arg * Location.TILEMAP_CELL_SIZE

var screen_size: Vector2
var tilemap_boundary: Rect2

func init_camera():
	if not fixed:
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

func move_camera(coords: Vector2i):
	while tilemap_position != coords:
		tilemap_position = Vector2(tilemap_position).move_toward(coords, fised_move_speed)
		#await get_tree().create_timer(0.1).timeout
	return 0
