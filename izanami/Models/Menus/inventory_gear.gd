extends Node

## CHILD NODES
@export var list: ItemList
@export var count: ItemList
@export var target_selector: EquipTargetSelector

## EXTERNAL PARAMETERS
@export var players: Party
@export var desc_box_container: BoxContainer

## WORKING VARIABLES
var inventory: Inventory
var selected_gear: Gear

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
		for i in inventory.gear_data:
			list.add_item(i)
			count.add_item(str(len(inventory.gear_data[i])))

func show_target_selector():
	target_selector.clear()
	for i in players.party:
		target_selector.add_item(i)

	target_selector.show()
	target_selector.player_list.grab_focus()

func choose_target(index: int):
	players.party[index].gear.equip_gear(selected_gear)
	target_selector.hide()


func _on_item_activated(index: int) -> void:
	selected_gear = inventory.get_entry_by_name(list.get_item_text(index))
	_on_item_selected(index)
	show_target_selector()


func _on_item_selected(index: int) -> void:
	list.select(index)
	count.select(index)
	var item = inventory.get_entry_by_name(list.get_item_text(index))
	if item:
		Global.show_description(item)
