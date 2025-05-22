extends Control

class_name Map

@export var scene: Node
@export var map_camera: Camera2D

var hidden_nodes: Array[Node] = []

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("map_key"):
		hide_map()


func setup_map():
	scene = get_tree().current_scene
	if scene:
		var map_size: Vector2 = scene.size() * 8
		var screen_size: Vector2 = get_viewport().size

		var map_scale = map_size / screen_size

		map_camera.zoom.x = min(map_size.x, map_scale.y) * 0.8
		map_camera.zoom.y = map_camera.zoom.x

		map_camera.position = scene.center() * 16
		print(map_camera.zoom)

func show_map():
	Global.players.freeze()
	map_camera.enabled = true
	map_camera.make_current()

	for i in scene.canvas_layer.get_children():
		if i.visible:
			hidden_nodes.append(i)
			i.hide()
	show()
	print(map_camera.position)


func hide_map():
	Global.players.unfreeze()
	map_camera.enabled = false

	for i in hidden_nodes:
		i.show()
	hidden_nodes.clear()

	hide()
