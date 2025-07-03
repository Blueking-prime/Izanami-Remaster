extends Camera2D

class_name PlayerCam

@export var players: Party

func init_camera():
	players.camera = self
	if not players.leader.moved.is_connected(_track_player):
		players.leader.moved.connect(_track_player)

func _track_player():
	position = players.leader.global_position
