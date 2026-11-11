extends Node2D

class_name TownApothecary

@export var stock: ResourceGroup
@export var dialogue_text: Dictionary [String, String] = {
	'speaker': "Lenarr, the Alchemist",
	'entrance_dialogue': "An indescribable miasma rises out as you open the door, the smell of ginseng, rabbit foot and other unknowable reagents",
	'greeting': "What would you like to purchase, adventurer!",
	'exit': "Leaving so soon?",
	'low_funds': "You don't have enough funds",
	'purchased': '',
	'sold': ''
}

@onready var overlay: UIOverlay = get_parent().overlay


func main():
	Checks.set_flags({'apothecary_visit': true})
	Global.players.freeze()

	Global.sell.connect(_sell_parser)

	await Global.show_text_box('', dialogue_text.entrance_dialogue)
	default_text()

	Global.show_shop_menu(stock)

func default_text():
	Global.show_text_box(dialogue_text.speaker, dialogue_text.greeting, true)


## ADD COMMENT ON PURCHASE TRIGGER
func buy_item():
	pass

func sell_item():
	pass

func exit_shop():
	var confirm = await Global.show_text_choice(dialogue_text.speaker, dialogue_text.exit)
	if confirm == 0:
		Global.sell.disconnect(_sell_parser)
		Global.shop_menu.queue_free()
		Global.exit_button.hide()
		overlay.load_ui_elements()
		overlay.show()
		Global.players.unfreeze()
	else:
		default_text()

func low_funds():
	await Global.show_text_box(dialogue_text.speaker, dialogue_text.low_funds)
	default_text()


## SIGNALS
func _sell_parser(condition: String):
	if condition == 'item sold':
		sell_item()
	if condition == 'item bought':
		buy_item()
	if condition == 'low funds':
		low_funds()
	if condition == 'exit':
		exit_shop()
