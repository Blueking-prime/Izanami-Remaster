extends StaticBody2D

class_name TownDemonitarium

@export var demonitarium_scene: PackedScene

func main():
	Global.warp(get_parent(), Global.demonitarium_scene)
