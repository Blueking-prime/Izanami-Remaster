extends Node

class_name DemonitariumFights

@export var demonitarium_display: OptionMenu

@export var stock: ResourceGroup

@onready var root_node: Demonitarium = get_parent().get_parent()

func main():
	demonitarium_display.demon_group = stock
	demonitarium_display.players = Global.players
	demonitarium_display.display_demons()
	demonitarium_display.show()
	demonitarium_display.options.grab_focus()
	Global.show_text_box(get_parent().dialogue_text.speaker, 'What do you want to fight?', true)


## ADD COMMENT ON PURCHASE TRIGGER
func fight_enemy(enemy_scene):
	demonitarium_display.hide()
	Global.exit_button.show()
	Global.sell.disconnect(get_parent()._sell_parser)

	var no_of_enemies = 1

	var battle: Battle = Global.battle_scene.instantiate()
	battle.no_of_enemies = no_of_enemies
	battle.demonitarium = root_node
	battle.enemy_set = [enemy_scene]
	#player.in_battle = true
	print('battle scene spawned')
	root_node.call_deferred("add_sibling", battle)
	root_node.hide()

func reset_from_battle():
	Global.players.freeze()
	await Global.show_text_box(get_parent().dialogue_text.speaker, 'Oh! So you survived?')
	Global.exit_button.show()
	Global.sell.connect(get_parent()._sell_parser)
	await get_parent().choose_option()

func close_shop():
	demonitarium_display.hide()
