extends Node2D

@onready var players: Party = get_parent().players

@export var stock: ResourceGroup

signal end_session

var cost

func main():
	await Global.show_text_box('', "A wave of heat rolls over you as soon as you step in.")
	Global.show_text_box("Old Smithy", "What would yer like to purchase, adventurer!")

	Global.dialog_choice_shop(players, stock)

## ADD COMMENT ON PURCHASE TRIGGER
