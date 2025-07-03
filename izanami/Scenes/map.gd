extends Camera2D

class_name Map

@export var scene: Node

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

		zoom.x = min(map_size.x, map_scale.y) * 0.8
		zoom.y = zoom.x

		position = scene.center() * 16

func show_map():
	print('show_map')
	Global.players.freeze()
	enabled = true
	make_current()

	for i in scene.canvas_layer.get_children():
		if i.visible:
			hidden_nodes.append(i)
			i.hide()


func hide_map():
	Global.players.unfreeze()
	enabled = false

	for i in hidden_nodes:
		i.show()
	hidden_nodes.clear()
