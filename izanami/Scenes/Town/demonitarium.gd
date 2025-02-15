extends Node

@export var crowley: Node
@export var quantity_input: SpinBox
@export var confirm_button: Button
@export var demonitarium_display: Control

@export var stock: ResourceGroup

@onready var players: Party = get_parent().players
@onready var back_button: Button = get_parent().back_button
@onready var overlay: UIOverlay = get_parent().overlay

func main():
	players.freeze()
	back_button.show()

	Global.sell.connect(_sell_parser)
	demonitarium_display.fight_demon.connect(fight_enemy)
	back_button.pressed.connect(exit_shop)

	await Global.show_text_box('', "Unholy sigils paint the walls and howling creatures cackle from cages hanging precariously overhead")
	await Global.show_text_box("Crowley", "Test your skills, adventurer... Anything you carve out is yours.")
	await choose_option()


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
	demonitarium_display.demon_group = stock
	demonitarium_display.players = players
	demonitarium_display.display_demons()
	demonitarium_display.show()
	demonitarium_display.list.grab_focus()
	Global.show_text_box("Crowley", 'What do you want to fight?', true)


func talk_to_crowley():
	crowley.crowley()

## ADD COMMENT ON PURCHASE TRIGGER
func fight_enemy(enemy_scene):
	demonitarium_display.hide()
	back_button.hide()
	quantity_input.hide()
	Global.sell.disconnect(_sell_parser)

	var no_of_enemies = 1

	var battle: Battle = Global.battle_scene.instantiate()
	battle.no_of_enemies = no_of_enemies
	battle.demonitarium = self
	battle.players = players
	battle.enemy_set = [enemy_scene]
	#player.in_battle = true
	get_parent().call_deferred("add_sibling", battle)

func reset_from_battle():
	players.freeze()
	get_parent().overlay.load_ui_elements()
	await Global.show_text_box('Crowley', 'Oh! So you survived?')
	back_button.show()
	Global.sell.connect(_sell_parser)
	await choose_option()

func exit_shop():
	var confirm = await Global.show_text_choice("Crowley", "Have your fears overcome you? ")
	if confirm == 0:
		Global.sell.disconnect(_sell_parser)
		demonitarium_display.hide()
		quantity_input.hide()
		back_button.hide()
		players.unfreeze()
		overlay.show()
	else:
		await choose_option()

func low_funds():
	await Global.show_text_box('Crowley', "Broke ass n*gga")
	await choose_option()


## SIGNALS
func _sell_parser(condition: String):
	if condition == 'low funds':
		low_funds()
	if condition == 'exit':
		exit_shop()
