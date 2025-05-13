extends StaticBody2D

@export var demonitarium_scene: PackedScene

func main():
	Global.warp(get_parent(), Global.demonitarium_scene)
