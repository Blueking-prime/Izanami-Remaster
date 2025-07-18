extends Node2D

class_name Location

@export var entrance: Vector2
@export var tilemap: TileMapLayer
@export var background: LocationBackground

@export var test_players: Party
@export var objectsort: Node

@export var camera: PlayerCam
@export var map_camera: Map
@export var freecam: FreeCam

@export var overlay: UIOverlay
@export var canvas_layer: CanvasLayer
@export var exit_button: Button

const TILEMAP_CELL_SIZE: int = 16

func _ready() -> void:
	load_scene()

func load_scene():
	if not Global.players:
		Global.players = test_players
		test_players = null
	else:
		_remove_test_players()

	if background: background.draw_background()

	if camera: camera.init_camera()

	if freecam: freecam.setup_map()

	if map_camera: map_camera.setup_map()

	if tilemap:
		tilemap.ready.connect(_on_map_loaded)

	Global.exit_button = exit_button
	if not Global.exit_button.pressed.is_connected(Global._on_shop_exit): Global.exit_button.pressed.connect(Global._on_shop_exit)

	overlay.load_ui_elements()

func _remove_test_players():
	if is_instance_valid(test_players):
		objectsort.remove_child(test_players)
		test_players.queue_free()

func add_players(_players: Party):
	objectsort.add_child(_players)

func size() -> Vector2:
	if tilemap:
		var _size: Vector2 = tilemap.get_used_rect().size  * TILEMAP_CELL_SIZE
		if _size: return _size

	return Vector2(1000, 1000)

func center() -> Vector2:
	if tilemap:
		var _center: Vector2 = tilemap.get_used_rect().get_center() * TILEMAP_CELL_SIZE
		if _center: return _center

	return Vector2(500, 500)

func _on_map_loaded():
	if camera: camera.init_camera()
	if freecam: freecam.setup_map()
	if map_camera: map_camera.setup_map()

	overlay.load_ui_elements()


func save():
	pass

func load_data(_data):
	pass
