extends StaticBody2D

class_name TownDemonitarium

@export var demonitarium_scene: PackedScene
@export var collision_shape: CollisionShape2D

func main():
	Global.players.freeze()
	Global.push_back_player(global_position, 20)
	#await get_tree().create_timer(0.1).timeout
	Global.warp.call_deferred(get_parent(), Global.demonitarium_scene)
