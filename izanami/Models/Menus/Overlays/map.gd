extends Control

class_name Map

@export var scene: Node
@export var map_camera: Camera2D

func setup_map():
	scene = get_tree().current_scene

	var map_size: Vector2 = scene.size() * 8
	var screen_size: Vector2 = get_viewport().size

	var map_scale = map_size / screen_size

	map_camera.zoom.x = min(map_size.x, map_scale.y)
	map_camera.zoom.y = map_camera.zoom.x

	print(map_camera.zoom)

func show_map():
	Global.player_party.freeze()
	map_camera.enabled = true
	map_camera.make_current()
	show()

func hide_map():
	Global.player_party.unfreeze()
	map_camera.enabled = false
	hide()
