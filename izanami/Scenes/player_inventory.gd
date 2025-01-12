extends ItemList


#@export_dir var item_location: String
@export var player: Player

@export var _items: Array = []
@export var _item_dict: Dictionary = {}
@onready var shop_list: ItemList = $"../ShopInventory"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_dict()


func update_dict():
	pass

func add_entry(entry: Variant):
	pass

func transfer_item(id: int):
	pass

func _on_item_activated(index: int) -> void:
	transfer_item(index)
	shop_list.update_dict()
	update_dict()
