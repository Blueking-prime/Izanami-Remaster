extends Node

class_name DemonitariumFights

@export var demonitarium_display: OptionMenu

@export var stock: ResourceGroup


func see_demons():
	demonitarium_display.demon_group = stock
	demonitarium_display.players = Global.players
	demonitarium_display.display_demons()
	demonitarium_display.show()
	demonitarium_display.options.grab_focus()
	Global.show_text_box("Crowley", 'What do you want to fight?', true)


## ADD COMMENT ON PURCHASE TRIGGER
func fight_enemy(enemy_scene):
	demonitarium_display.hide()
	get_parent().back_button.hide()
	get_parent().quantity_input.hide()
	Global.sell.disconnect(get_parent()._sell_parser)

	var no_of_enemies = 1

	var battle: Battle = Global.battle_scene.instantiate()
	battle.no_of_enemies = no_of_enemies
	battle.demonitarium = self
	battle.players = Global.player_party
	battle.enemy_set = [enemy_scene]
	#player.in_battle = true
	get_parent().call_deferred("add_sibling", battle)

func reset_from_battle():
	Global.player_party.freeze()
	await Global.show_text_box('Crowley', 'Oh! So you survived?')
	get_parent().back_button.show()
	Global.sell.connect(get_parent()._sell_parser)
	await get_parent().choose_option()
