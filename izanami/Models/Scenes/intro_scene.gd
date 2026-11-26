extends Node

class_name IntroScene

#@export var canvas_layer: CanvasLayer
@export var character_selector: CharacterSelector

@export var intro_cutscene: JSON
@export var party_scene: PackedScene


func play_intro():
	if not is_instance_valid(Global.players):
		Global.players = party_scene.instantiate()

	#await Dialogue.show_cutscene(intro_cutscene)
	character_selector.load_menu()
	character_selector.show()

func implement_starting_materials(player: Player):
	match player.classname:
		'Scion':
			Global.players.gold += 1000
			var gear: Gear = Global.get_resource('Royal Armor', 'Gear')
			Global.players.inventory.add_entry(gear)
			player.gear.equip_gear(gear)
		'Maken':
			var gear: Gear = Global.get_resource('Soul Sword', 'Gear')
			Global.players.inventory.add_entry(gear)
			player.gear.equip_gear(gear)
		'Doctor':
			for i in 10:
				Global.players.inventory.add_entry(Global.get_resource('Medicine', 'Item'))

func play_post_select_intro():
	Global.set_seed()
	Global.warp(null, Global.demonitarium_scene)
	get_parent().queue_free()


func _on_character_select_player_created(player: Player) -> void:
	player.lock = true
	Checks.player_name = player.character_name
	Global.players.clear_party()
	Global.players.switch_leader(Global.players.party.find(player))
	implement_starting_materials(player)
	play_post_select_intro()
