extends Camera2D

@export var players: Party

func init_camera():
	players.camera = self
	players.leader.moved.connect(_track_player)

func _track_player():
	position = players.leader.global_position
