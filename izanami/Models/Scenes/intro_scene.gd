extends Node

class_name IntroScene

@export var canvas_layer: CanvasLayer
@export var character_selector: CharacterSelector

@export_file('*.json') var cutscene_1: String
@export_file('*.json') var cutscene_2: String
@export var starter_town: PackedScene
@export var party_scene: PackedScene


func play_intro():
	if not is_instance_valid(Global.players):
		Global.players = party_scene.instantiate()

	Dialogue.show_cutscene(cutscene_1)
	character_selector.load_menu()
	character_selector.show()

func play_post_select_intro():
	Global.set_seed()
	Dialogue.show_cutscene(cutscene_2)
	load_town()

func load_town():
	var town: Town = starter_town.instantiate()
	get_tree().unload_current_scene()
	add_sibling(town)
	town.add_players()
	get_tree().current_scene = town


func _on_character_select_player_created(player: Player) -> void:
	player.lock = true
	Global.players.switch_leader(Global.players.party.find(player))
	play_post_select_intro()
