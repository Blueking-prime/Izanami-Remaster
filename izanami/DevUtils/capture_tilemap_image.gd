# Credit Rodrigo on Stack Overflow: https://stackoverflow.com/a/79135337
extends ReferenceRect

@export var zoom=6.0
@export var tilemap : TileMapLayer = null
var starting_position := Vector2.ZERO

func _ready() -> void:
	setup_tilemap()

func setup_tilemap():
	if tilemap == null:
		printerr("Please set the tilemap")
	else:
		starting_position = Vector2(tilemap.get_used_rect().position*tilemap.tile_set.tile_size)
		size = Vector2(tilemap.get_used_rect().size*tilemap.tile_set.tile_size)
		print("TILEMAP coordinates are ", starting_position, size)

func _hide_stuff():
	# hide nodes you dont want to show on screenshots
	pass

func _show_stuff():
	# dont forget to show what you hide before
	pass

func capture_image():
	print("[Start Capture...]")
	#_hide_stuff()
	var camera=Camera2D.new()
	self.add_child(camera)
	camera.anchor_mode=Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
	camera.enabled = true
	camera.make_current()

	#camera.zoom=Vector2(zoom,zoom)
	camera.position= starting_position

	var tree=get_tree()
	tree.paused = true
	await tree.process_frame

	var full_rect= Rect2(starting_position, size)
	var viewport_size=get_viewport().size / zoom

	var image=Image.create_empty(full_rect.size.x, full_rect.size.y, false, Image.FORMAT_RGB8)

	while camera.position.y < full_rect.size.y:
		while camera.position.x < full_rect.size.x:
			await tree.process_frame
			var segment=get_viewport().get_texture().get_image()
			#segment.flip_y()
			image.blit_rect(segment, Rect2(Vector2.ZERO,segment.get_size()), camera.position - starting_position)
			camera.position.x+=viewport_size.x

		camera.position.x=full_rect.position.x
		camera.position.y+=viewport_size.y

	image.save_png("res://screenshot-tilemap-%d.png" % [zoom])
	get_tree().paused = false
	camera.queue_free()
	print("[END   Capture...]")

func _unhandled_input(_event):
	if Input.is_key_pressed(KEY_SPACE):
		capture_image()
