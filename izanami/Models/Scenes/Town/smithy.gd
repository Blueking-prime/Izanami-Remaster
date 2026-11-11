extends Node2D

class_name TownSmithy

@export var stock: ResourceGroup

@export var dialogue_text: Dictionary [String, String] = {
	'speaker': "Old Smithy",
	'entrance_dialogue': "A wave of heat rolls over you as soon as you step in.",
	'greeting': "What would yer like to purchase, adventurer!",
	'exit': "Leaving so soon?",
	'low_funds': "You don't have enough funds",
	'purchased': '',
	'sold': ''
}

@onready var overlay: UIOverlay = get_parent().overlay

func main():
	Global.players.freeze()
	Global.sell.connect(_sell_parser)

	await Global.show_text_box('', dialogue_text.entrance_dialogue)
	default_text()

	Global.show_shop_menu(stock)

func default_text():
	Global.show_text_box(dialogue_text.speaker, dialogue_text.greeting, true)


## SMITHY SPECIFIC FUNCTIONS
func equip_new_gear():
	pass


## ADD COMMENT ON PURCHASE TRIGGER
func buy_item():
	Checks.smithy_buy = true

func sell_item():
	pass

func exit_shop():
	var confirm = await Global.show_text_choice(dialogue_text.speaker, dialogue_text.exit)
	if confirm == 0:
		Global.sell.disconnect(_sell_parser)
		Global.shop_menu.queue_free()
		Global.exit_button.hide()
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
