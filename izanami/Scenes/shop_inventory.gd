extends Node

class_name ShopInventory

## CHILD NODES
@export var list: ItemList
@export var count: ItemList
@export var cost: ItemList

## EXTERNAL PARAMETERS
@export var desc_box_container: BoxContainer
@export var item_group: ResourceGroup
@onready var player_list: PlayerInventory = $"../PlayerInventory"

## WORKING VARIABLES
@export var _items: Array = []
@export var _item_dict: Dictionary

signal sell(condition)

func _ready() -> void:
	Global.description_box_parent = desc_box_container
	load_stock()

func load_stock():
	if item_group:
		item_group.load_all_into(_items)
		update_listing()

func update_listing():
	_item_dict.clear()
	for i in _items:
		if i.name in _item_dict:
			_item_dict[i.name] += 1
		else:
			_item_dict.get_or_add(i.name, 1)

	list.clear()
	count.clear()
	cost.clear()
	for i in _item_dict:
		list.add_item(i)
		count.add_item(str(_item_dict[i]))
		cost.add_item(str(_get_item(i).price))

func add_entry(entry: Variant):
	_items.append(entry)
	update_listing()

func _get_item(item: String):
	for i in _items:
		if i.name == item:
			return i

func transfer_item(id: int):
	var item_name = list.get_item_text(id)
	var item = _get_item(item_name)
	if not _check_cost(item):
		return
	_item_dict[item_name] -= 1
	player_list.add_entry(item)
	_items.erase(item)

func _check_cost(item: Variant) -> bool:
	print(player_list.gold)
	if item.price <= player_list.gold:
		player_list.gold -= item.price
		sell.emit('item bought')
		return true
	else:
		sell.emit('low funds')
		return false

func _on_item_activated(index: int) -> void:
	transfer_item(index)
	update_listing()

func _on_item_selected(index: int) -> void:
	list.select(index)
	count.select(index)
	cost.select(index)

	if Global.description_box:
		Global.description_box.queue_free()
	Global.show_description(_get_item(list.get_item_text(index)))
