extends OptionMenu

class_name ShopInventoryMenu

## EXTERNAL PARAMETERS
@export var desc_box_container: BoxContainer
@export var item_group: ResourceGroup
@onready var player_list: PlayerInventoryMenu = $"../PlayerInventory"

## WORKING VARIABLES
@export var inventory: Dictionary


func _ready() -> void:
	Global.description_box_parent = desc_box_container
	#Global.sell.connect(_sell)
	load_stock()

#func _sell(cond: String):
	#print(cond)
	#Global.sell.disconnect(_sell)

func load_stock():
	if item_group:
		inventory.clear()
		for i in item_group.load_all():
			if i.name in inventory:
				inventory[i.name].append(i)
			else:
				inventory.get_or_add(i.name, [i])
		update_listing()

func update_listing():
	options.clear()

	for i in inventory:
		options.add_item(
			i,
			[
				str(len(inventory[i])),
				str(_get_item(i).price)
			]
		)

func add_entry(entry: Variant):
	if entry.name in inventory:
		inventory[entry.name].append(entry)
	else:
		inventory.get_or_add(entry.name, [entry])
	update_listing()

func remove_item(entry: Variant):
	inventory[entry.name].erase(entry)
	if not len(inventory[entry.name]):
		inventory.erase(entry.name)
	update_listing()

func _get_item(item: String):
	return inventory[item][0]

func transfer_item(id: int):
	var item_name = options.get_item_text(id)
	var item = _get_item(item_name)
	if not _check_cost(item):
		return
	player_list.add_entry(item)
	remove_item(item)

func _check_cost(item: Variant) -> bool:
	if item.price <= Global.players.gold:
		Global.players.gold -= item.price
		Global.sell.emit('item bought')
		return true
	else:
		Global.sell.emit('low funds')
		return false

func _on_item_activated(index: int) -> void:
	transfer_item(index)
	update_listing()

func _on_item_selected(index: int) -> void:
	Global.show_description(_get_item(options.get_item_text(index)))
