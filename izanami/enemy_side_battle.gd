extends Node2D

var enemies: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Spawn enemies here
	enemies = get_children()
	var screen_size = get_viewport_rect().size
	print(screen_size)
	var enemies_size = enemies.size()
	var x_coord
	var y_coord
	for i in enemies_size:
		x_coord = round(screen_size.x * .1 * enemies[i].ally)
		if x_coord < 0:
			x_coord = screen_size.x + x_coord
		y_coord = round((screen_size.y / enemies_size) * i + screen_size.y * 0.1)
		
		enemies[i].position = Vector2(x_coord, y_coord)
		print(enemies[i].name, enemies[i].position)
