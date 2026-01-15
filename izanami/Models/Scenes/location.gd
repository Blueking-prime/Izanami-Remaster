extends Node2D

class_name Location

@export var entrance: Vector2:
	get():
		if entrance_area:
			return entrance_area.global_position + (Vector2.DOWN * TILEMAP_CELL_SIZE * 3)
		else :
			return entrance
	set(arg): entrance = arg

@export var tilemap: TileMapLayer
@export var background: LocationBackground
@export var entrance_area: Area2D

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

	#if get_tree().current_scene == self: connect_signals()

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

	if tilemap: tilemap.ready.connect(_on_map_loaded)

	Global.exit_button = exit_button
	if not Global.exit_button.pressed.is_connected(Global._on_shop_exit): Global.exit_button.pressed.connect(Global._on_shop_exit)

	Audio.call_deferred('set_background_music')

	overlay.load_ui_elements()

	connect_signals()

func connect_signals():
	Global.players.leader.detector.left_map.connect(_on_left_map)


func disconnect_signals():
	Global.players.leader.detector.left_map.disconnect(_on_left_map)


func _remove_test_players():
	if is_instance_valid(test_players):
		objectsort.remove_child(test_players)
		test_players.queue_free()

func add_players():
	objectsort.add_child(Global.players)

func remove_players():
	objectsort.remove_child(Global.players)

func size() -> Vector2:
	if tilemap:
		var _size: Vector2 = tilemap.get_used_rect().size  * TILEMAP_CELL_SIZE
		if _size: return _size

	return Vector2(2000, 2000)

func center() -> Vector2:
	if tilemap:
		var _center: Vector2 = tilemap.get_used_rect().get_center() * TILEMAP_CELL_SIZE
		if _center: return _center

	return size() / 2

func _on_map_loaded():
	#if camera: camera.init_camera()
	if freecam: freecam.setup_map()
	if map_camera: map_camera.setup_map()

	overlay.load_ui_elements()

func reset_from_battle():
	if get_tree().current_scene != self:
		get_tree().current_scene = self
	Audio.call_deferred('set_background_music')
	overlay.load_ui_elements()
	Global.players.reset_battle_collision()
	overlay.show()

func go_to_overworld():
	Global.players.freeze()
	var overworld: Overworld = Global.overworld_scene.instantiate()
	overworld.source_location = self
	add_sibling(overworld)

func handle_out_of_bounds(): pass

func save():
	pass

func load_data(_data):
	pass


func _on_left_map():
	if not background.confirm_player_location(): handle_out_of_bounds()
