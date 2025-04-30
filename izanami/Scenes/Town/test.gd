extends StaticBody2D

@export var test_player: Player

func main():
	#remove_child(test_player)
	Global.player_party.remove_from_party(Global.player_party.leader)
	print(Global.player_party.leader.character_name)
	get_parent().load_scene()
	get_parent().overlay.show()
