extends StaticBody2D

@export var test_scene: PackedScene

func main():
	#remove_child(test_player)
	print(Global.players.gold)

	get_parent().overlay.load_ui_elements()
	get_parent().overlay.show()
