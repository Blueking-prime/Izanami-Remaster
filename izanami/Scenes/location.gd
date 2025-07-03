extends Node2D

class_name Location

@export var entrance: Vector2
@export var tilemap: TileMapLayer
@export var background: LocationBackground

@export var test_players: Party
@export var objectsort: Node
@export var players: Party

@export var overlay: UIOverlay
@export var canvas_layer: CanvasLayer
@export var camera: PlayerCam
@export var freecam: FreeCam

func _ready() -> void:
	load_scene()

func load_scene():
	if not Global.players:
		Global.players = players
	else:
		if is_instance_valid(test_players):
			objectsort.remove_child(test_players)
		test_players.queue_free()

		players = Global.players

	if background: background.draw_background()

	if camera:
		camera.players = players
		camera.init_camera()

	if freecam:
		freecam.players = players
		freecam.setup_map()

	overlay.load_ui_elements()


func remove_test_players():
	test_players.get_parent().remove_child(test_players)

func remove_players():
	players.get_parent().remove_child(players)

func add_players(_players: Party):
	tilemap.add_sibling(_players)

func size() -> Vector2:
	if tilemap:
		return tilemap.get_used_rect().size
	else :
		return Vector2(1000, 1000)

func center() -> Vector2:
	if tilemap:
		return tilemap.get_used_rect().get_center()
	else :
		return Vector2(500, 500)

func save():
	pass

func load_data(_data):
	pass
