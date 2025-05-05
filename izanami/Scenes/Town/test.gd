extends StaticBody2D

@export var test_scene: PackedScene

func main():
	#remove_child(test_player)
	Global.warp(get_parent(), Global.town_scene)
