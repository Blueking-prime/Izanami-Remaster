extends Camera2D

class_name FreeCam

@export var speed: int = 500

func setup_map():
	position = Global.players.leader.global_position

func _process(delta: float) -> void:
	if Global.players and Global.players.frozen:
		var direction = Vector2()
		direction = Input.get_vector('ui_left', 'ui_right', 'ui_up', 'ui_down')

		if direction.length():
			direction = direction.normalized()
			position += direction * speed * delta

func show_cam():
	Global.players.freeze()
	enabled = true
	make_current()

func hide_cam():
	Global.players.unfreeze()
	enabled = false
