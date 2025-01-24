extends Node

@export var crowley: Node
@export var quantity_input: SpinBox
@export var confirm_button: Button

@onready var players: Party = get_parent().players

func main():
	await Global.show_text_box('', "Unholy sigils paint the walls and howling creatures cackle from cages hanging precariously overhead")
	await Global.show_text_box("Crowley", "Test your skills, adventurer... Anything you carve out is yours.")
	choose_option()


func choose_option():
	var option = await Global.show_text_choice("Crowley", "What would you like to purchase? ", ["Buy Mag", "See Demons", "Talk to Crowley"])
	match option:
		1: buy_mag()
		2: see_demons()
		3: talk_to_crowley()


func buy_mag():
	Global.show_text_box("Crowley", "Whatever you want, I got it.", true)

	await confirm_button.pressed
	var x = quantity_input.value

	var cost = 10 * x
	var confirm = await Global.show_text_choice("Crowley", "That will be % yen. | Balance: %" % [cost, players.gold])
	if confirm == 0:
		if players.gold >= cost:
			players.gold -= cost
			players.mag += x
		else:
			await Global.show_text_box('System', "You don't have enough Yen")

func see_demons():
	var fights = players.demon_training
	while true:
		var fight = await Global.show_text_choice('What do you want to fight', fights)
		#try:
		var cost = fights[fight]
		var confirm =  await Global.show_text_choice("Crowley", "That will be {cost} yen | Balance: {players.gold}")
		if confirm:
			if players.gold >= cost:
				var enemy
				#enemy = getattr(enemy_models, fight)()
				Global.battle_scene.instantiate()
				Global.battle_scene.stuff = [players, [enemy]]
			else:
				await Global.show_text_box('', "Broke ass n*gga")
		#except KeyError:
			break

func talk_to_crowley():
	crowley.crowley()
