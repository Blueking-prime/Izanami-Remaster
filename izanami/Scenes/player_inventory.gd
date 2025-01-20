extends ItemList


#@export_dir var item_location: String
@export var players: Party
var player

@onready var shop_list: ItemList = $"../ShopInventory"

var inventory

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if players:
		player = players.leader
	load_stock()

func load_stock():
	if player:
		inventory = player.inventory
	update_listing()


func update_listing():
	clear()
	if inventory:
		for i in inventory.inventory_data:
			add_item(i)
			add_item(str(inventory.inventory_data[i]))

func add_entry(entry: Variant):
	inventory.add_entry(entry)
	update_listing()

func transfer_item(id: int):
	var item = inventory.get_entry_by_name(get_item_text(id))
	if 'equipped' in item:
		if item.equipped:
			print("Can't sell equipped items")
			return
	inventory.remove_entry(item)
	shop_list.add_entry(item)

func _on_item_activated(index: int) -> void:
	transfer_item(index)
	update_listing()


func _on_item_selected(index: int) -> void:
	if Global.description_box:
		Global.description_box.queue_free()
	var item = inventory.get_entry_by_name(get_item_text(index))
	Global.show_description(item)
