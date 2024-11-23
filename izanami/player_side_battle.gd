extends Node2D

var players: Array = []
var index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Spawn players here
	players = get_children()
	var screen_size = get_viewport_rect().size
	print(screen_size)
	var players_size = players.size()
	var x_coord
	var y_coord
	for i in players_size:
		x_coord = round(screen_size.x * .1 * 1) # Replace 1 with players[i].ally
		if x_coord < 0:
			x_coord = screen_size.x + x_coord
		y_coord = round((screen_size.y / players_size) * i + screen_size.y * 0.1)
		
		players[i].position = Vector2(x_coord, y_coord)
		print(players[i].name, players[i].position)
