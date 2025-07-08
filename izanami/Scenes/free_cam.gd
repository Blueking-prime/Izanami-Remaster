extends Camera2D

class_name FreeCam

@export var speed: int = 500

@export var zoom_step: Vector2 = Vector2(0.1, 0.1)
@export var zoom_max: Vector2 = Vector2(4, 4)
@export var zoom_min: Vector2 = zoom_step

var initial_zoom: Vector2

func setup_map():
	initial_zoom = zoom
	position = Global.players.leader.global_position

func _process(delta: float) -> void:
	if Global.players and Global.players.frozen:
		var direction = Vector2()
		direction = Input.get_vector('ui_left', 'ui_right', 'ui_up', 'ui_down')

		if direction.length():
			direction = direction.normalized()
			position += direction * speed * delta

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('zoom_in'):
		if zoom < zoom_max:
			zoom += zoom_step
	elif event.is_action_pressed('zoom_out'):
		if zoom > zoom_min:
			zoom -= zoom_step
	elif event.is_action_pressed('zoom_reset'):
		zoom = initial_zoom

func show_cam():
	Global.players.freeze()
	enabled = true
	make_current()

func hide_cam():
	Global.players.unfreeze()
	enabled = false
