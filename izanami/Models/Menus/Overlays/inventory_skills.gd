extends VBoxContainer

@export var skill_menu_card_scene: PackedScene

## EXTERNAL PARAMETERS
@export var desc_box_container: BoxContainer
@export var target_selector: Options


func _ready() -> void:
	Global.description_box_parent = desc_box_container

func load_stock():
	_clear_data_cards()
	if Global.players:
		for i in Global.players.party:
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


func _on_visibility_changed() -> void:
	if get_child(0) and visible:
		get_child(0).options.grab_focus()
