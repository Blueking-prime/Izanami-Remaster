extends OptionMenu

class_name PlayerInventoryMenu

## EXTERNAL PARAMETERS
@export var players: Party
@export var desc_box_container: BoxContainer
@onready var shop_list: ShopInventoryMenu = $"../ShopInventory"

## WORKING VARIABLES
var gold
var inventory

func _ready() -> void:
	Global.description_box_parent = desc_box_container
	load_stock()

func load_stock():
	if players:
		gold = players.gold
		inventory = players.inventory
	update_listing()


func update_listing():
	options.clear()
	if inventory:
		for i in inventory.inventory_data:
			options.add_item(
				i,
				str(len(inventory.inventory_data[i])),
				str(inventory.get_entry_by_name(i).price),
			)

func add_entry(entry: Variant):
	inventory.add_entry(entry)
	update_listing()

func transfer_item(id: int):
	var item = inventory.get_entry_by_name(options.get_item_text(id))
	if 'equipped' in item:
		if item.equipped:
			print("Can't sell equipped items")
			return
	inventory.remove_entry(item)
	gold += item.price
	Global.sell.emit('item sold')
	shop_list.add_entry(item)

func _on_item_activated(index: int) -> void:
	transfer_item(index)
	update_listing()

func _on_item_selected(index: int) -> void:
	Global.show_description(inventory.get_entry_by_name(options.get_item_text(index)))
