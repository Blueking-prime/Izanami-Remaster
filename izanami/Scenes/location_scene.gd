extends Node2D

class_name Location

@export var entrance: Vector2
@export var tilemap: TileMapLayer
@export var background: LocationBackground

@export var test_players: Party
@export var players: Party

@export var overlay: UIOverlay
@export var canvas_layer: CanvasLayer
@export var camera: Camera2D
@export var freecam: FreeCam

func _ready() -> void:
	load_scene()

func load_scene():
	if not Global.players:
		Global.players = players
	else:
		remove_child(test_players)
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

func size():
	#return tile_map.get_used_rect().size
	pass

func center():
	#return tile_map.center()
	pass

func save():
	pass

func load_data(data):
	pass
