extends Node2D

class_name Shop

@onready var players: Party = get_parent().players

@export var stock: ResourceGroup


func main():
	players.freeze()
	Global.sell.connect(_sell_parser)

	await Global.show_text_box('', "A wave of heat rolls over you as soon as you step in.")
	default_text()

	Global.show_shop_menu(players, stock)

func default_text():
	Global.show_text_box("Old Smithy", "What would yer like to purchase, adventurer!", true)


## SMITHY SPECIFIC FUNCTIONS
func equip_new_gear():
	pass


## ADD COMMENT ON PURCHASE TRIGGER
func buy_item():
	pass

func sell_item():
	pass

func exit_shop():
	var confirm = await Global.show_text_choice('Old Smithy', "Leaving so soon? ")
	if confirm == 0:
		Global.sell.disconnect(_sell_parser)
		Global.shop_menu.queue_free()
		players.unfreeze()
	else:
		default_text()

func low_funds():
	await Global.show_text_box('System', "You don't have enough funds")
	default_text()


## SIGNALS
func _sell_parser(condition: String):
	if condition == 'item sold':
		buy_item()
	if condition == 'item bought':
		sell_item()
	if condition == 'low funds':
		low_funds()
	if condition == 'exit':
		exit_shop()
