extends Node

@export var crowley: Node
@export var quantity_input: SpinBox
@export var confirm_button: Button
@export var demonitarium_display: Control

@export var unlocked_demons: ResourceGroup

@onready var players: Party = get_parent().players

func main():
	players.freeze()

	Global.sell.connect(_sell_parser)

	await Global.show_text_box('', "Unholy sigils paint the walls and howling creatures cackle from cages hanging precariously overhead")
	await Global.show_text_box("Crowley", "Test your skills, adventurer... Anything you carve out is yours.")
	await choose_option()

	players.unfreeze()


func choose_option():
	var option = await Global.show_text_choice("Crowley", "What would you like to purchase? ", ["Buy Mag", "See Demons", "Talk to Crowley"])
	match option:
		0: await buy_mag()
		1: await see_demons()
		2: await talk_to_crowley()


func buy_mag():
	Global.show_text_box("Crowley", "Whatever you want, I got it.", true)

	quantity_input.show()
	quantity_input.grab_focus()

	confirm_button.show()

	await confirm_button.pressed
	var x = quantity_input.value

	var cost = 10 * x
	var confirm = await Global.show_text_choice("Crowley", "That will be %d yen. | Balance: %d" % [cost, players.gold])
	if confirm == 0:
		if players.gold >= cost:
			players.gold -= cost
			print(players.gold)
			players.mag += x
		else:
			await Global.show_text_box('System', "You don't have enough Yen")

	quantity_input.hide()
	confirm_button.hide()


func see_demons():
	demonitarium_display.show()
	demonitarium_display.players = players
	Global.show_text_box("Crowley", 'What do you want to fight?', true)
	#var cost = fights[fight]
	#var confirm =  await Global.show_text_choice("Crowley", "That will be {cost} yen | Balance: {players.gold}")
	#if confirm == 0:
		#if players.gold >= cost:
			#var enemy
			##enemy = getattr(enemy_models, fight)()
			#Global.battle_scene.instantiate()
			#Global.battle_scene.stuff = [players, [enemy]]
		#else:
			#await Global.show_text_box('', "Broke ass n*gga")


func talk_to_crowley():
	crowley.crowley()

## ADD COMMENT ON PURCHASE TRIGGER
func fight_enemy(enemy_scene):
	demonitarium_display.hide()

	var no_of_enemies = 1

	var battle: Battle = Global.battle_scene.instantiate()
	battle.no_of_enemies = no_of_enemies
	#battle.dungeon = self
	battle.players = players
	battle.enemy_set = [enemy_scene]
	#player.in_battle = true
	get_parent().call_deferred("add_sibling", battle)


func exit_shop():
	var confirm = await Global.show_text_choice("Crowley", "Have your fears overcome you? ")
	if confirm == 0:
		Global.sell.disconnect(_sell_parser)
		Global.shop_menu.queue_free()
		players.unfreeze()
	else:
		await choose_option()

func low_funds():
	await Global.show_text_box('Crowley', "Broke ass n*gga")
	await choose_option()


## SIGNALS
func _sell_parser(condition: String, enemy_scene):
	if condition == 'item sold':
		fight_enemy(enemy_scene)
	if condition == 'low funds':
		low_funds()
	if condition == 'exit':
		exit_shop()
