extends Node

## CHILD NODES
@export var list: ItemList
@export var count: ItemList

## EXTERNAL PARAMETERS
@export var players: Party
@export var desc_box_container: BoxContainer
@export var target_selector: TargetSelector

## WORKING VARIABLES
var inventory: Inventory
var selected_item_name: String

func _ready() -> void:
	Global.description_box_parent = desc_box_container
	load_stock()

func load_stock():
	players = Global.player_party
	if players:
		inventory = players.inventory
	update_listing()

func update_listing():
	list.clear()
	count.clear()

	if inventory:
		for i in inventory.item_data:
			list.add_item(i)
			count.add_item(str(len(inventory.item_data[i])))

func show_target_selector():
	target_selector.clear()
	for i in players.party:
		target_selector.add_item(i)

	target_selector.show()
	target_selector.player_list.grab_focus()

func choose_target(index: int):
	players.leader.use_item(selected_item_name, players.party[index])
	target_selector.hide()
	update_listing()

func _on_item_activated(index: int) -> void:
	selected_item_name = list.get_item_text(index)
	if inventory.get_entry_by_name(selected_item_name).aoe:
		players.leader.use_item(selected_item_name, players.party)
		update_listing()
	else:
		show_target_selector()
	_on_item_selected(index)

func _on_item_selected(index: int) -> void:
	list.select(index)
	count.select(index)
	var item = inventory.get_entry_by_name(list.get_item_text(index))
	if item:
		Global.show_description(item)
