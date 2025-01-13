extends ItemList


#@export_dir var item_location: String
@export var player: Player

@onready var shop_list: ItemList = $"../ShopInventory"

var inventory

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory = player.inventory
	update_listing()


func update_listing():
	clear()
	for i in inventory.inventory_data:
		add_item(i)
		add_item(str(inventory.inventory_data[i]))

func add_entry(entry: Variant):
	inventory.add_entry(entry)
	update_listing()

func transfer_item(id: int):
	var item = inventory.get_entry_by_name(get_item_text(id))
	shop_list.add_entry(item)

func _on_item_activated(index: int) -> void:
	transfer_item(index)
	update_listing()
