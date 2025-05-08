extends Node2D

class_name Town

@export var entrance: Vector2

@export var canvas_layer: CanvasLayer
@export var overlay: UIOverlay
@export var back_button: Button
@export var camera: Camera2D
@export var tile_map: TileMapLayer

@export var church: Node
@export var smithy: Node
@export var apothecary: Node
@export var dungeon: Node
@export var demonitarium: Node
@export var palace: Node
@export var test: Node

@export var players: Party

var locations = ["Palace", "Church", "Smithy", "Apothecary", "Demonitorium", "Dungeon"]
var actions = ['Talk', "Go Somewhere", 'Status']
var characters = ["Kobaneko", "White"]

func _ready() -> void:
	load_scene()


func load_scene():
	if not Global.player_party:
		Global.player_party = players
	else:
		players = Global.player_party

	#if not players.leader.detector.hit_building.is_connected(_check_building):
		#print('Connect detector')
	players.leader.detector.hit_building.connect(_check_building)

	camera.players = players
	camera.init_camera()
	overlay.load_ui_elements()


func _check_building(node: Variant):
	overlay.hide()
	match node:
		church: await church.main()
		dungeon: await dungeon.main()
		smithy: await smithy.main()
		apothecary: await apothecary.main()
		demonitarium: await demonitarium.main()
		palace: await palace.main()
		test: await test.main()

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_end"):
		#func_church()


func size() -> Vector2:
	# return walls.get_used_rect().size
	# Replace with above when tilemap is created
	return Vector2(100, 100)

func center() -> Vector2:
	#return walls.center()
	# Replace with above when tilemap is created
	return Vector2(500, 500)


func save() -> TownSaveData:
	var save_data: TownSaveData = TownSaveData.new()

	save_data.apothecary_stock = apothecary.stock
	save_data.demonitarium_stock = demonitarium.stock
	save_data.smithy_stock = smithy.stock

	return save_data

func load_data(data: TownSaveData):
	apothecary.stock = data.apothecary_stock
	demonitarium.stock = data.demonitarium_stock
	smithy.stock = data.smithy_stock

	print('Town Data Loaded')
