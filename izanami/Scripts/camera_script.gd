extends Camera2D

class_name PlayerCam

func init_camera():
	if is_instance_valid(Global.players):
		Global.players.camera = self
		if not Global.players.leader.moved.is_connected(_track_player):
			Global.players.leader.moved.connect(_track_player)

func _track_player():
	position = Global.players.leader.global_position
