extends Node2D

class_name TownApothecary

@export var stock: ResourceGroup

@onready var overlay: UIOverlay = get_parent().overlay


func main():
	Global.players.freeze()

	Global.sell.connect(_sell_parser)

	await Global.show_text_box('', "An indescribable miasma rises out as you open the door, the smell of ginseng, rabbit foot and other unknowable reagents")
	default_text()

	Global.show_shop_menu(Global.players, stock)

func default_text():
	Global.show_text_box("Lenarr, the Alchemist", "What would you like to purchase, adventurer!", true)


## ADD COMMENT ON PURCHASE TRIGGER
func buy_item():
	pass

func sell_item():
	pass

func exit_shop():
	var confirm = await Global.show_text_choice("Lenarr, the Alchemist", "Leaving so soon? ")
	if confirm == 0:
		Global.sell.disconnect(_sell_parser)
		Global.shop_menu.queue_free()
		overlay.load_ui_elements()
		overlay.show()
		Global.players.unfreeze()
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
