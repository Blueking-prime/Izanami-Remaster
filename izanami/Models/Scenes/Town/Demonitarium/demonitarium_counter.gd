extends StaticBody2D

class_name DemonitariumCounter

@export var mag: Node
@export var shop: Node

@export var dialogue_text: Dictionary [String, Variant] = {
	'speaker': "Crowley",
	'entrance_dialogue': "Unholy sigils paint the walls and howling creatures cackle from cages hanging precariously overhead",
	'greeting': "Test your skills, adventurer... Anything you carve out is yours.",
	'choice_text': "What would you like? ",
	'exit': "Have your fears overcome you? ",
	'low_funds': "You seem to lack the coin for this",
	'shop_options': [
		"Buy Mag",
		'Do shop thing',
		"Talk to Keep"
	],
	'purchased': '',
	'sold': ''
}

@export var shopkeep: NPC

func main():
	Global.players.freeze()

	Global.exit_button.show()
	Global.sell.connect(_sell_parser)

	await Global.show_text_box('', dialogue_text.entrance_dialogue)
	await Global.show_text_box(dialogue_text.speaker, dialogue_text.greeting)
	await choose_option()


func choose_option():
	var option = await Global.show_text_choice(dialogue_text.speaker, dialogue_text.choice_text, dialogue_text.shop_options)
	match option:
		0: await mag.buy_mag()
		1: await use_shop()
		2: await talk_to_keep()
	return option

func use_shop():
	await shop.main()

func talk_to_keep():
	await shopkeep.dialogue()

func hide_shop_menu():
	shop.close_shop()
	mag.quantity_input.hide()

func exit_shop():
	var confirm = await Global.show_text_choice(dialogue_text.speaker, dialogue_text.exit)
	if confirm == 0:
		Global.sell.disconnect(_sell_parser)
		Global.exit_button.hide()
		hide_shop_menu()
		Global.players.unfreeze()
		get_parent().overlay.show()
	else:
		await choose_option()

func low_funds():
	await Global.show_text_box(dialogue_text.speaker, dialogue_text.low_funds)
	await choose_option()

## SIGNALS
func _sell_parser(condition: String):
	if condition == 'low funds':
		low_funds()
	if condition == 'exit':
		exit_shop()
