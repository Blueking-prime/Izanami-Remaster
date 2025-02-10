extends Node

@export var skill_menu_card_scene: PackedScene

## EXTERNAL PARAMETERS
@export var players: Party
@export var desc_box_container: BoxContainer
@export var target_selector: TargetSelector


func _ready() -> void:
	Global.description_box_parent = desc_box_container
	load_stock()

func load_stock():
	players = Global.player_party
	_clear_data_cards()
	if players:
		for i in players.party:
			create_card(i)

func create_card(player: Player):
	var card: InventorySkillCard = skill_menu_card_scene.instantiate()
	card.desc_box_container = desc_box_container
	card.target_selector = target_selector
	card.player = player
	card.load_stock()

	add_child(card)

func _clear_data_cards():
	var children = get_children()
	if children:
		for i in children:
			remove_child(i)
			i.queue_free()
