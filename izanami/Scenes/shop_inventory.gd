extends ItemList


#@export_dir var item_location: String
@export var _items: Array = []
@export var item_group: ResourceGroup
@export var _item_dict: Dictionary
@onready var player_list: ItemList = $"../PlayerInventory"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if item_group:
		item_group.load_all_into(_items)
		update_dict()


func update_dict():
	_item_dict.clear()
	for i in _items:
		if i.name in _item_dict:
			_item_dict[i] += 1
		else:
			_item_dict.get_or_add(i.name, 1)

	clear()
	for i in _item_dict:
		add_item(i)
		add_item(str(_item_dict[i]))

func add_entry(entry: Variant):
	_items.append(entry)
	update_dict()

func transfer_item(id: int):
	var item = get_item_text(id)

	_item_dict[item] -= 1
	for i in _items:
		if i.name == item:
			player_list.add_entry(i)
			_items.erase(i)

func _on_item_activated(index: int) -> void:
	transfer_item(index)
	player_list.update_dict()
	update_dict()
