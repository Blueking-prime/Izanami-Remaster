extends StaticBody2D

@export var demonitarium_scene: PackedScene

func main():
	var demonitarium: Demonitarium = demonitarium_scene.instantiate()

	demonitarium.remove_child(demonitarium.get_node("Players"))
	demonitarium.players = Global.player_party

	get_parent().remove_child(Global.player_party)
	demonitarium.tile_map.add_child(Global.player_party)

	add_sibling(demonitarium)
	get_tree().current_scene = demonitarium

	Global.player_party.leader.global_position = demonitarium.entrance

	get_parent().queue_free()

	print(get_tree().current_scene)

	print('Demonitarium Loaded')
