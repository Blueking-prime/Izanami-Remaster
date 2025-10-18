extends StaticBody2D

class_name DemonitariumCounter

@export var fights: DemonitariumFights
@export var upgrades: DemonitariumUpgrades
@export var mag: Node

@export var crowley: Node
func main():
	Global.players.freeze()

	Global.exit_button.show()
	Global.sell.connect(_sell_parser)

	await Global.show_text_box('', "Unholy sigils paint the walls and howling creatures cackle from cages hanging precariously overhead")
	await Global.show_text_box("Crowley", "Test your skills, adventurer... Anything you carve out is yours.")
	await choose_option()


func choose_option():
	var option = await Global.show_text_choice("Crowley", "What would you like to purchase? ", ["Buy Mag", "See Demons", "Upgrade Skills", "Talk to Crowley"])
	match option:
		0: await mag.buy_mag()
		1: await fights.see_demons()
		2: await upgrades.upgrade_skills()
		3: await talk_to_crowley()

func talk_to_crowley():
	#crowley.crowley()
	pass

func exit_shop():
	var confirm = await Global.show_text_choice("Crowley", "Have your fears overcome you? ")
	if confirm == 0:
		Global.sell.disconnect(_sell_parser)
		fights.demonitarium_display.hide()
		upgrades.upgrade_menu.hide()
		mag.quantity_input.hide()
		Global.exit_button.hide()
		Global.players.unfreeze()
		get_parent().overlay.show()
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
