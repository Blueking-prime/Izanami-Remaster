extends Node2D

class_name Demonitarium

@export var counter: DemonitariumCounter
@export var warp_points: Node2D
@export var canvas_layer: CanvasLayer
@export var overlay: UIOverlay
@export var tile_map: TileMapLayer
@export var entrance: Vector2

@export var players: Party

func _ready() -> void:
	load_scene()

func load_scene():
	if not Global.player_party:
		Global.player_party = players
	else:
		players = Global.player_party

	Global.player_party.leader.detector.hit_building.connect(_check_building)

	overlay.load_ui_elements()

func _check_building(node: Variant):
	overlay.hide()
	match node:
		counter: await counter.main()
		warp_points: await warp_points.main()

func size() -> Vector2:
	# return walls.get_used_rect().size
	# Replace with above when tilemap is created
	return Vector2(100, 100)

func center() -> Vector2:
	#return walls.center()
	# Replace with above when tilemap is created
	return Vector2(500, 500)


func save():
	#var save_data =

	#save_data.demonitarium_stock = counter.stock

	#return save_data
	pass

func load_data(data):
	counter.stock = data.demonitarium_stock

	print('Town Data Loaded')
