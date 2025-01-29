extends Node

## CHILD NODES
@export var list: ItemList
@export var count: ItemList

## EXTERNAL PARAMETERS
@export var players: Party
@export var desc_box_container: BoxContainer

## WORKING VARIABLES
var inventory

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

func _on_item_activated(index: int) -> void:
	pass

func _on_item_selected(index: int) -> void:
	list.select(index)
	count.select(index)
	if Global.description_box:
		Global.description_box.queue_free()
	Global.show_description(inventory.get_entry_by_name(list.get_item_text(index)))
