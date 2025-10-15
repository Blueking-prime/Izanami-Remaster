extends Camera2D

class_name Map

@export var scene: Node

@export var map_zoom_factor: float = 0.8

var hidden_nodes: Array[Node] = []

func setup_map():
	scene = get_tree().current_scene
	if scene:
		var map_size: Vector2 = scene.size()
		var screen_size: Vector2 = get_viewport().size
		var map_scale = map_size / screen_size
		#print('Map Size: ', map_size)
		#print('Screen Size: ', screen_size)
		#print('Map Scale: ', map_scale)

		if map_size and map_scale:
			zoom.x = min(map_size.x, map_scale.y) * map_zoom_factor
			zoom.y = zoom.x

		#print('Zoom: ', zoom)
		position = scene.center()

func show_map():
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
