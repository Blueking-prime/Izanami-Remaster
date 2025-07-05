extends OptionMenu

class_name PlayerInventoryMenu

## EXTERNAL PARAMETERS
@export var test_players: Party
@export var desc_box_container: BoxContainer
@onready var shop_list: ShopInventoryMenu = $"../ShopInventory"

func _ready() -> void:
	Global.description_box_parent = desc_box_container
	load_stock()

func load_stock():
	if not Global.players:
		Global.players = test_players
	else:
		if is_instance_valid(test_players):
			get_parent().remove_child.call_deferred(test_players)
			test_players.queue_free()
	update_listing()


func update_listing():
	options.clear()
	if Global.players.inventory:
		for i in Global.players.inventory.inventory_data:
			options.add_item(
				i,
				[
					str(len(Global.players.inventory.inventory_data[i])),
					str(Global.players.inventory.get_entry_by_name(i).price)
				]
			)

func add_entry(entry: Variant):
	Global.players.inventory.add_entry(entry)
	update_listing()

func transfer_item(id: int):
	var item = Global.players.inventory.get_entry_by_name(options.get_item_text(id))
	if 'equipped' in item:
		if item.equipped:
			print("Can't sell equipped items")
			return
	Global.players.inventory.remove_entry(item)
	Global.players.gold += item.price
	Global.sell.emit('item sold')
	shop_list.add_entry(item)

func _on_item_activated(index: int) -> void:
	transfer_item(index)
	update_listing()

func _on_item_selected(index: int) -> void:
	Global.show_description(Global.players.inventory.get_entry_by_name(options.get_item_text(index)))
